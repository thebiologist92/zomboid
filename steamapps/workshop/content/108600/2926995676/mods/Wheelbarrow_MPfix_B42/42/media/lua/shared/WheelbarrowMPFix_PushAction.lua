-- Wheelbarrow MP Fix - accion "Push" autoritativa en servidor.
--
-- Coge la carretilla del suelo y la pone en ambas manos SIN exigir hueco en el
-- inventario (la carretilla pesa 20 y no cabe en el inventario normal; el juego hace
-- lo mismo con los objetos pesados en ISEquipHeavyItem).
--
-- Va en shared/ porque el servidor ejecuta complete(): NetTimedAction busca esta clase
-- por su nombre global y la reconstruye llamando a new() con los campos que se llaman
-- igual que sus parametros (character, square, itemId). No renombrar esos campos.
--
-- La carretilla se identifica por casilla + ID de objeto, no por su posicion en la
-- lista de objetos: si cliente y servidor no coinciden, no se toca nunca otro objeto.

require "TimedActions/ISBaseTimedAction"

WheelbarrowMPFixPushAction = ISBaseTimedAction:derive("WheelbarrowMPFixPushAction")

WheelbarrowMPFixPushAction.TYPES = { HCWoodenwheelbarrow = true }

local DURATION = 50

function WheelbarrowMPFixPushAction.findWorldItem(square, itemId)
    if not square or not itemId then return nil end
    local objects = square:getWorldObjects()
    for i = 0, objects:size() - 1 do
        local worldItem = objects:get(i)
        local item = worldItem and worldItem:getItem()
        if item and item:getID() == itemId and WheelbarrowMPFixPushAction.TYPES[item:getType()] then
            return worldItem
        end
    end
    return nil
end

function WheelbarrowMPFixPushAction:isValid()
    return WheelbarrowMPFixPushAction.findWorldItem(self.square, self.itemId) ~= nil
end

function WheelbarrowMPFixPushAction:waitToStart()
    self.character:faceLocation(self.square:getX(), self.square:getY())
    return self.character:shouldBeTurning()
end

function WheelbarrowMPFixPushAction:start()
    self:setActionAnim("Loot")
    self:setAnimVariable("LootPosition", "Low")
end

function WheelbarrowMPFixPushAction:perform()
    if ISInventoryPage then ISInventoryPage.renderDirty = true end
    ISBaseTimedAction.perform(self)
end

-- Quitar del suelo como ISTransferAction (origen "floor") y equipar a dos manos como
-- ISEquipHeavyItem. Si la carretilla ya no esta (otro jugador la cogio), no hace nada.
function WheelbarrowMPFixPushAction:complete()
    local worldItem = WheelbarrowMPFixPushAction.findWorldItem(self.square, self.itemId)
    if not worldItem then return false end
    local item = worldItem:getItem()

    forceDropHeavyItems(self.character)

    if DesignationZoneAnimal and DesignationZoneAnimal.removeItemFromGround then
        DesignationZoneAnimal.removeItemFromGround(worldItem)
    end
    self.square:transmitRemoveItemFromSquare(worldItem)
    self.square:removeWorldObject(worldItem)
    item:setWorldItem(nil)
    item:setJobDelta(0.0)

    local inventory = self.character:getInventory()
    inventory:AddItem(item)
    sendAddItemToContainer(inventory, item)

    self.character:setPrimaryHandItem(item)
    self.character:setSecondaryHandItem(item)
    if isServer() then
        sendEquip(self.character)
    end
    return true
end

function WheelbarrowMPFixPushAction:getDuration()
    if self.character:isTimedActionInstant() then return 1 end
    return DURATION
end

function WheelbarrowMPFixPushAction:new(character, square, itemId)
    local o = ISBaseTimedAction.new(self, character)
    o.square = square
    o.itemId = itemId
    o.maxTime = o:getDuration()
    return o
end
