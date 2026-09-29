require "TimedActions/ISBaseTimedAction"
require "TimedActions/ISEquipWeaponAction"
require "ZCR/Core"

ISZCRTakeCart = ISBaseTimedAction:derive("ISZCRTakeCart")

function ISZCRTakeCart:isValid()
    local world = self.worldObject
    if not world or not world:getSquare() or not ZCR.isCart(world:getItem()) then return false end
    if self.character:isDead() or self.character:getVehicle() then return false end
    local square = self.character:getSquare()
    if not square or not square:canReachTo(world:getSquare()) then return false end
    if not world:getSquare():getWorldObjects():contains(world) then return false end
    if (isClient() or isServer()) and not SafeHouse.isSafehouseAllowLoot(world:getSquare(), self.character) then
        return false
    end
    return true
end

function ISZCRTakeCart:start()
    self:setActionAnim("Loot")
    self:setAnimVariable("LootPosition", "Low")
    self:setOverrideHandModels(nil, nil)
    self.character:reportEvent("EventLootItem")
end

function ISZCRTakeCart:perform()
    ISInventoryPage.renderDirty = true
    ISBaseTimedAction.perform(self)
end

function ISZCRTakeCart:complete()
    -- Revalidate on the authority at completion: a second pickup must fail.
    if not self:isValid() then return false end
    local world = self.worldObject
    local item = world:getItem()
    local square = world:getSquare()
    forceDropHeavyItems(self.character)
    local source = item:getContainer()
    if source then source:DoRemoveItem(item) end
    square:transmitRemoveItemFromSquare(world)
    world:removeFromWorld()
    world:removeFromSquare()
    world:setSquare(nil)
    item:setWorldItem(nil)
    self.character:getInventory():AddItem(item)
    ZCR.updateModel(item)
    sendAddItemToContainer(self.character:getInventory(), item)
    self.character:setPrimaryHandItem(item)
    self.character:setSecondaryHandItem(item)
    sendEquip(self.character)
    return true
end

function ISZCRTakeCart:getDuration()
    return self.character:isTimedActionInstant() and 1 or 30
end

function ISZCRTakeCart:new(character, worldObject)
    local o = ISBaseTimedAction.new(self, character)
    o.worldObject = worldObject
    o.maxTime = o:getDuration()
    o.stopOnWalk = true
    o.stopOnRun = true
    return o
end
