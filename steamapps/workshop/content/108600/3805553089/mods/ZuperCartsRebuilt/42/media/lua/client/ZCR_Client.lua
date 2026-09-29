require "ZCR/Core"
require "ISUI/ISInventoryPaneContextMenu"
require "TimedActions/ISEquipHeavyItem"
require "TimedActions/ISEquipWeaponAction"
require "TimedActions/ISUnequipAction"
require "TimedActions/ISZCRTakeCart"
require "PZAPI/ModOptions"

ZCR.Client = {}
local Client = ZCR.Client

function Client.push(player, item)
    if not player or player:isDead() or player:getVehicle() or not ZCR.isCart(item) then return end
    if player:isItemInBothHands(item) or player:hasTimedActions() then return end
    local world = item:getWorldItem()
    if world then
        local square = world:getSquare()
        if not square or not luautils.walkAdj(player, square) then return end
        ISTimedActionQueue.add(ISZCRTakeCart:new(player, world))
        return
    end
    if not item:getContainer() then return end
    if item:getContainer() == player:getInventory() then
        ISInventoryPaneContextMenu.equipWeapon(item, true, true, player:getPlayerNum())
    else
        ISInventoryPaneContextMenu.equipHeavyItem(player, item)
    end
end

function Client.release(player, item)
    if not player or player:hasTimedActions() or not ZCR.isCart(item) then return end
    if player:getPrimaryHandItem() ~= item and player:getSecondaryHandItem() ~= item then return end
    -- Native heavy-item unequip drops the same item, including its contents.
    ISTimedActionQueue.add(ISUnequipAction:new(player, item, 10))
end

function Client.inventoryMenu(playerNum, context, entries)
    local player = getSpecificPlayer(playerNum)
    if not player then return end
    local items = ISInventoryPane.getActualItems(entries)
    if #items ~= 1 or not ZCR.isCart(items[1]) then return end
    local item = items[1]
    if player:isHandItem(item) then
        context:addOptionOnTop(getText("UI_ZCR_Release", item:getName()), player, Client.release, item)
    elseif not player:getVehicle() then
        context:addOptionOnTop(getText("UI_ZCR_Push", item:getName()), player, Client.push, item)
    end
end

function Client.worldMenu(playerNum, context, objects, test)
    if test then return end
    local player = getSpecificPlayer(playerNum)
    if not player or player:getVehicle() then return end
    local held = player:getPrimaryHandItem()
    if ZCR.isCart(held) then
        context:addOption(getText("UI_ZCR_Release", held:getName()), player, Client.release, held)
    end
    local seenSquares, seenItems = {}, {}
    for _, object in ipairs(objects) do
        local square = object:getSquare()
        if square and not seenSquares[square] then
            seenSquares[square] = true
            local worldItems = square:getWorldObjects()
            for i = 0, worldItems:size() - 1 do
                local item = worldItems:get(i):getItem()
                if ZCR.isCart(item) and not seenItems[item] then
                    seenItems[item] = true
                    context:addOption(getText("UI_ZCR_Push", item:getName()), player, Client.push, item)
                end
            end
        end
    end
end

local function updateContainer(container)
    if not container then return end
    ZCR.updateModel(container:getContainingItem())
    local items = container:getItems()
    for i = 0, items:size() - 1 do ZCR.updateModel(items:get(i)) end
end

function Client.refresh()
    for n = 0, getNumActivePlayers() - 1 do
        local player = getSpecificPlayer(n)
        if player then
            local held = player:getPrimaryHandItem()
            if ZCR.updateModel(held) then player:resetModelNextFrame() end
            updateContainer(player:getInventory())
            local loot = getPlayerLoot(n)
            if loot then updateContainer(loot.inventory) end
        end
    end
end

function Client.updatePlayer(player)
    local item = player:getPrimaryHandItem()
    if ZCR.isCart(item) and player:isItemInBothHands(item) then
        if ZCR.updateModel(item) then player:resetModelNextFrame() end
        player:setVariable("RightHandMask", "holdingtrolleyright")
    elseif player:getVariableString("RightHandMask") == "holdingtrolleyright" then
        player:clearVariable("RightHandMask")
    end
end

function Client.loadSquare(square)
    if not square then return end
    local objects = square:getWorldObjects()
    for i = 0, objects:size() - 1 do ZCR.updateModel(objects:get(i):getItem()) end
end

function Client.toggle()
    local player = getSpecificPlayer(0)
    if not player or player:isDead() or player:getVehicle() or player:hasTimedActions() then return end
    local held = player:getPrimaryHandItem()
    if ZCR.isCart(held) then Client.release(player, held); return end
    local nearest, distance
    local x, y, z = math.floor(player:getX()), math.floor(player:getY()), player:getZ()
    for dx = -1, 1 do
        for dy = -1, 1 do
            local square = getCell():getGridSquare(x + dx, y + dy, z)
            if square and not square:isBlockedTo(player:getSquare()) then
                local objects = square:getWorldObjects()
                for i = 0, objects:size() - 1 do
                    local item = objects:get(i):getItem()
                    local d = dx * dx + dy * dy
                    if ZCR.isCart(item) and (not distance or d < distance) then
                        nearest, distance = item, d
                    end
                end
            end
        end
    end
    if nearest then Client.push(player, nearest) end
end

local options
if PZAPI and PZAPI.ModOptions then
    options = PZAPI.ModOptions:create("ZuperCartsRebuilt", "ZuperCarts Rebuilt")
    options:addKeyBind("ToggleCart", getText("UI_ZCR_Keybind"), Keyboard.KEY_G)
end
function Client.keyPressed(key)
    if getCore():isKey("Toggle Chat", key) then return end
    if ISUIHandler and ISUIHandler.allUIVisible == false then return end
    if UIManager.getSpeedControls() and UIManager.getSpeedControls():getCurrentGameSpeed() == 0 then return end
    if getCore():isDoingTextEntry() then return end
    local binding = options and options:getOption("ToggleCart")
    local toggleKey = binding and binding:getValue() or Keyboard.KEY_G
    if key == toggleKey then Client.toggle() end
end

Events.OnFillInventoryObjectContextMenu.Add(Client.inventoryMenu)
Events.OnFillWorldObjectContextMenu.Add(Client.worldMenu)
Events.OnPlayerUpdate.Add(Client.updatePlayer)
Events.OnContainerUpdate.Add(Client.refresh)
Events.LoadGridsquare.Add(Client.loadSquare)
Events.OnKeyPressed.Add(Client.keyPressed)
