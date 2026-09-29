require "UnifiedCarts/Core"
require "UnifiedCarts/CartData"
require "UnifiedCarts/TimedActions/ISUnifiedCartTake"
require "ISUI/ISInventoryPaneContextMenu"
require "TimedActions/ISUnequipAction"
require "TimedActions/ISDropWorldItemAction"

UnifiedCarts.Client = UnifiedCarts.Client or {}
local Client = UnifiedCarts.Client
local lastHeld = {}

local function heldBoth(player, item)
    return item
        and item == player:getPrimaryHandItem()
        and item == player:getSecondaryHandItem()
end

function Client.equip(player, cart)
    if not player or player:isDead() or player:getVehicle()
        or not UnifiedCarts.isCart(cart) or player:hasTimedActions() then
        return
    end

    ISInventoryPaneContextMenu.equipHeavyItem(player, cart)
end

function Client.release(player, cart)
    if not player or player:isDead() or player:hasTimedActions()
        or not UnifiedCarts.isCart(cart) or not heldBoth(player, cart) then
        return
    end

    local square = player:getCurrentSquare()
    if not square then return end

    local action = ISDropWorldItemAction:new(
        player, cart, square, 0.5, 0.5, 0.0, 0, false
    )
    if action then
        ISTimedActionQueue.add(action)
    end
end

function Client.worldPickup(player, worldObject)
    if not player or player:isDead() or player:getVehicle()
        or not worldObject or not worldObject:getSquare() then
        return
    end

    local item = worldObject:getItem()
    if not UnifiedCarts.isPushCart(item) then return end

    local square = worldObject:getSquare()
    if not player:getSquare() or not player:getSquare():canReachTo(square) then
        if not luautils.walkAdj(player, square) then return end
    end

    ISTimedActionQueue.add(ISUnifiedCartTake:new(player, worldObject))
end

function Client.inventoryContext(playerNum, context, entries)
    local player = getSpecificPlayer(playerNum)
    if not player then return end

    local items = ISInventoryPane.getActualItems(entries)
    if #items ~= 1 then return end

    local item = items[1]
    if not UnifiedCarts.isCart(item) then return end

    if heldBoth(player, item) then
        context:addOptionOnTop("Drop Cart", player, Client.release, item)
    elseif not player:getVehicle() then
        context:addOptionOnTop("Push Cart", player, Client.equip, item)
    end
end

function Client.worldContext(playerNum, context, objects, test)
    if test then return end

    local player = getSpecificPlayer(playerNum)
    if not player or player:getVehicle() then return end

    local held = player:getPrimaryHandItem()
    if UnifiedCarts.isCart(held) and heldBoth(player, held) then
        context:addOptionOnTop("Drop Cart", player, Client.release, held)
        return
    end

    local seen = {}
    for i = 1, #objects do
        local object = objects[i]
        local item = object and object:getItem()

        if item and UnifiedCarts.isPushCart(item) and not seen[item:getID()] then
            seen[item:getID()] = true
            context:addOption("Push Cart", player, Client.worldPickup, object)
        end
    end
end

function Client.onContainerUpdate(container)
    if not container or not container.getContainingItem then return end

    local cart = container:getContainingItem()
    if UnifiedCarts.isCart(cart) then
        UnifiedCarts.updateModel(cart)
        local world = cart:getWorldItem()
        if world then
            pcall(function() world:updateSprite() end)
        end
    end
end

function Client.onPlayerUpdate(player)
    if not player or player:isDead() then return end

    local primary = player:getPrimaryHandItem()
    local holding = UnifiedCarts.isCart(primary) and heldBoth(player, primary)
    local key = player:getPlayerNum()
    local previous = lastHeld[key] == true

    if holding then
        UnifiedCarts.applyCartPose(player)
        UnifiedCarts.updateModel(primary)
        if not previous then
            player:resetEquippedHandsModels()
        end
    elseif previous then
        UnifiedCarts.clearCartPose(player)
        player:resetEquippedHandsModels()
    end

    lastHeld[key] = holding
end

function Client.onLoadGridSquare(square)
    if not square then return end

    local objects = square:getWorldObjects()
    if not objects then return end

    for i = 0, objects:size() - 1 do
        local world = objects:get(i)
        local item = world:getItem()
        if UnifiedCarts.isCart(item) then
            UnifiedCarts.updateModel(item)
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(Client.inventoryContext)
Events.OnFillWorldObjectContextMenu.Add(Client.worldContext)
Events.OnPlayerUpdate.Add(Client.onPlayerUpdate)
Events.OnContainerUpdate.Add(Client.onContainerUpdate)
Events.LoadGridsquare.Add(Client.onLoadGridSquare)

return Client
