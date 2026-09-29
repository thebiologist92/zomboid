-- Identity-preserving cart helpers. No item creation or inventory mutation here.
ZCR = ZCR or {}
ZCR.types = {}
local variants = {
    TrolleyContainer = "TrolleyModel",
    TrolleyContainerBlue = "TrolleyModelBlue",
    TrolleyContainerGray = "TrolleyModelGray",
    TrolleyContainerGreen = "TrolleyModelGreen",
    TrolleyContainerRed = "TrolleyModelRed",
    CartContainer = "CartModel",
    DollyContainer = "ZCR_DollyHeldV2",
}
for name, model in pairs(variants) do
    ZCR.types["TMC." .. name] = model
    ZCR.types["TMC." .. name .. "2"] = model
end

function ZCR.cartKind(item)
    if not item or not ZCR.types[item:getFullType()] then return nil end
    local name = item:getFullType()
    if string.find(name, "DollyContainer", 1, true) then return "Dollies" end
    if string.find(name, "TrolleyContainer", 1, true) then return "Trolleys" end
    return "Carts"
end

function ZCR.isCart(item)
    return item ~= nil and ZCR.types[item:getFullType()] ~= nil
end

-- Called by the engine on both client and server for every container insertion.
-- Reject carts (including carts nested in bags), and all container cycles.
function ZCR.acceptItem(destination, item)
    if not destination or not item then return false end
    local seen = {}
    local function allowed(candidate)
        if ZCR.isCart(candidate) then return false end
        if not candidate:IsInventoryContainer() then return true end
        local contents = candidate:getInventory()
        if contents == destination or seen[contents] then return false end
        seen[contents] = true
        local items = contents:getItems()
        for i = 0, items:size() - 1 do
            if not allowed(items:get(i)) then return false end
        end
        return true
    end
    return allowed(item)
end

ZCR.worldModels = {
    ZCR_DollyHeldV2 = "ZCR_DollyWorldV2",
    ZCR_DollyHeldV2Full = "ZCR_DollyWorldV2Full",
}

function ZCR.updateModel(item)
    if not ZCR.isCart(item) then return false end
    local model = ZCR.types[item:getFullType()]
    if item:getInventory():getItems():size() > 0 then model = model .. "Full" end
    local worldModel = ZCR.worldModels[model] or model
    local changed = item:getStaticModel() ~= model or item:getWorldStaticModel() ~= worldModel
    if changed then
        item:setStaticModel(model)
        item:setWorldStaticModel(worldModel)
    end
    return changed
end

return ZCR
