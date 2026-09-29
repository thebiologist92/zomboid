UnifiedCarts = UnifiedCarts or {}
UnifiedCarts.VERSION = "0.1.0"
UnifiedCarts.API_VERSION = 1
UnifiedCarts.CartTypes = UnifiedCarts.CartTypes or {}
UnifiedCarts._registryFrozen = false
UnifiedCarts.Config = { FillPartialThreshold = 0.33, FillFullThreshold = 0.66, PickupDuration = 30 }

function UnifiedCarts.registerCart(fullType, data)
    if UnifiedCarts._registryFrozen then return false, "cart registry is frozen" end
    if type(fullType) ~= "string" or not fullType:match("^[%w_]+%.[%w_]+$") then
        return false, "fullType must use Module.Item format"
    end
    if type(data) ~= "table" or type(data.name) ~= "string" or data.name == "" then
        return false, "data.name is required"
    end
    if UnifiedCarts.CartTypes[fullType] then return false, "cart type already registered: "..fullType end

    local entry = {
        name=data.name, description=data.description or "", capacity=data.capacity or 50,
        weightReduction=data.weightReduction or 90, runSpeedModifier=data.runSpeedModifier or 0.75,
        movementMode=data.movementMode or "push", visualModels=data.visualModels
    }
    if type(entry.capacity) ~= "number" or entry.capacity <= 0 then return false, "capacity must be > 0" end
    if type(entry.weightReduction) ~= "number" or entry.weightReduction < 0 or entry.weightReduction > 100 then return false, "weightReduction must be 0-100" end
    if type(entry.runSpeedModifier) ~= "number" or entry.runSpeedModifier <= 0 then return false, "runSpeedModifier must be > 0" end
    if entry.movementMode ~= "push" and entry.movementMode ~= "pull" then return false, "movementMode must be push or pull" end
    if type(entry.visualModels) ~= "table" or type(entry.visualModels.empty) ~= "string" or type(entry.visualModels.partial) ~= "string" or type(entry.visualModels.full) ~= "string" then
        return false, "visualModels must contain empty, partial and full"
    end
    UnifiedCarts.CartTypes[fullType] = entry
    return true
end

function UnifiedCarts.getCartData(cart) return cart and UnifiedCarts.CartTypes[cart:getFullType()] or nil end
function UnifiedCarts.getCartDataByType(fullType) return UnifiedCarts.CartTypes[fullType] end
function UnifiedCarts.isCart(item) return item ~= nil and UnifiedCarts.CartTypes[item:getFullType()] ~= nil end
function UnifiedCarts.isPushCart(item) local d=UnifiedCarts.getCartData(item); return d ~= nil and d.movementMode=="push" end
function UnifiedCarts.isPullCart(item) local d=UnifiedCarts.getCartData(item); return d ~= nil and d.movementMode=="pull" end

function UnifiedCarts.applyCartPose(character)
    if not character then return end
    character:setVariable("Weapon","cart")
    character:setVariable("RightHandMask","holdingcartright")
    character:setVariable("LeftHandMask","holdingcartleft")
end

function UnifiedCarts.clearCartPose(character)
    if not character then return end
    character:setVariable("Weapon","")
    character:setVariable("RightHandMask","")
    character:setVariable("LeftHandMask","")
end

function UnifiedCarts.getFillState(cart)
    local container=cart and cart:getItemContainer()
    if not container then return "empty" end
    local capacity=container:getCapacity()
    if not capacity or capacity<=0 then return "empty" end
    local fill=container:getCapacityWeight()/capacity
    if fill>=UnifiedCarts.Config.FillFullThreshold then return "full"
    elseif fill>=UnifiedCarts.Config.FillPartialThreshold then return "partial"
    end
    return "empty"
end

function UnifiedCarts.getModelName(cart)
    local d=UnifiedCarts.getCartData(cart)
    if not d then return nil end
    return d.visualModels[UnifiedCarts.getFillState(cart)] or d.visualModels.empty
end

function UnifiedCarts.updateModel(cart)
    if not UnifiedCarts.isCart(cart) then return false end
    local model=UnifiedCarts.getModelName(cart)
    if not model then return false end
    local changed=false
    if cart:getStaticModel()~=model then cart:setStaticModel(model); changed=true end
    if cart:getWorldStaticModel()~=model then cart:setWorldStaticModel(model); changed=true end
    return changed
end

function UnifiedCarts.acceptItem(destination,item)
    if not destination or not item then return false end
    if UnifiedCarts.isCart(item) then return false end
    if destination==item or item:getContainer()==destination then return false end
    return true
end

return UnifiedCarts
