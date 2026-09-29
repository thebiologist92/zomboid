UnifiedCarts = UnifiedCarts or {}
UnifiedCarts.VERSION = "0.1.0"
UnifiedCarts.API_VERSION = 1
UnifiedCarts.CartTypes = UnifiedCarts.CartTypes or {}
UnifiedCarts._registryFrozen = false
UnifiedCarts.Config = {
    FillPartialThreshold = 0.33,
    FillFullThreshold = 0.66,
    PickupDuration = 30,
}

function UnifiedCarts.registerCart(fullType, data)
    if UnifiedCarts._registryFrozen then return false, "cart registry is frozen" end
    if type(fullType) ~= "string" or not fullType:match("^[%w_]+%.[%w_]+$") then
        return false, "fullType must use Module.Item format"
    end
    if type(data) ~= "table" or type(data.name) ~= "string" or data.name == "" then
        return false, "data.name is required"
    end
    if UnifiedCarts.CartTypes[fullType] then
        return false, "cart type already registered: "..fullType
    end

    local entry = {
        name = data.name,
        description = data.description or "",
        capacity = data.capacity or 50,
        weight = data.weight or 0,
        weightReduction = data.weightReduction or 90,
        runSpeedModifier = data.runSpeedModifier or 0.75,
        movementMode = data.movementMode or "push",
        visualModels = data.visualModels,
        spawnRooms = data.spawnRooms or {},
    }

    if type(entry.capacity) ~= "number" or entry.capacity <= 0 then return false, "capacity must be > 0" end
    if type(entry.weight) ~= "number" or entry.weight < 0 then return false, "weight must be >= 0" end
    if type(entry.weightReduction) ~= "number" or entry.weightReduction < 0 or entry.weightReduction > 100 then return false, "weightReduction must be 0-100" end
    if type(entry.runSpeedModifier) ~= "number" or entry.runSpeedModifier <= 0 then return false, "runSpeedModifier must be > 0" end
    if entry.movementMode ~= "push" and entry.movementMode ~= "pull" then return false, "movementMode must be push or pull" end
    if type(entry.visualModels) ~= "table"
        or type(entry.visualModels.empty) ~= "string"
        or type(entry.visualModels.partial) ~= "string"
        or type(entry.visualModels.full) ~= "string" then
        return false, "visualModels must contain empty, partial and full"
    end

    UnifiedCarts.CartTypes[fullType] = entry
    return true
end

function UnifiedCarts.getCartData(cart)
    if not cart then return nil end
    return UnifiedCarts.CartTypes[cart:getFullType()]
end

function UnifiedCarts.getCartDataByType(fullType)
    return UnifiedCarts.CartTypes[fullType]
end

function UnifiedCarts.isCart(item)
    if not item then return false end
    local ok, fullType = pcall(function() return item:getFullType() end)
    return ok and fullType ~= nil and UnifiedCarts.CartTypes[fullType] ~= nil
end

function UnifiedCarts.isPushCart(item)
    local data = UnifiedCarts.getCartData(item)
    return data ~= nil and data.movementMode == "push"
end

function UnifiedCarts.isPullCart(item)
    local data = UnifiedCarts.getCartData(item)
    return data ~= nil and data.movementMode == "pull"
end

function UnifiedCarts.applyCartPose(character)
    if not character then return end
    character:setVariable("Weapon", "cart")
    character:setVariable("RightHandMask", "unifiedHoldingCartRight")
    character:setVariable("LeftHandMask", "unifiedHoldingCartLeft")
end

function UnifiedCarts.clearCartPose(character)
    if not character then return end
    character:setVariable("Weapon", "")
    character:setVariable("RightHandMask", "")
    character:setVariable("LeftHandMask", "")
end

function UnifiedCarts.getFillState(cart)
    local container = cart and cart:getItemContainer()
    if not container then return "empty" end

    local capacity = container:getCapacity()
    if not capacity or capacity <= 0 then return "empty" end

    local fill = container:getCapacityWeight() / capacity
    if fill >= UnifiedCarts.Config.FillFullThreshold then return "full" end
    if fill >= UnifiedCarts.Config.FillPartialThreshold then return "partial" end
    return "empty"
end

function UnifiedCarts.getModelName(cart)
    local data = UnifiedCarts.getCartData(cart)
    if not data then return nil end
    return data.visualModels[UnifiedCarts.getFillState(cart)] or data.visualModels.empty
end

function UnifiedCarts.updateModel(cart)
    if not UnifiedCarts.isCart(cart) then return false end

    local model = UnifiedCarts.getModelName(cart)
    if not model then return false end

    local changed = false
    if cart:getStaticModel() ~= model then
        cart:setStaticModel(model)
        changed = true
    end
    if cart:getWorldStaticModel() ~= model then
        cart:setWorldStaticModel(model)
        changed = true
    end

    local world = cart:getWorldItem()
    if changed and world and world.updateSprite then
        world:updateSprite()
    end

    return changed
end

function UnifiedCarts.acceptItem(destination, item)
    if not destination or not item then return false end
    if UnifiedCarts.isCart(item) then return false end
    if destination == item or item:getContainer() == destination then return false end
    return true
end

return UnifiedCarts
