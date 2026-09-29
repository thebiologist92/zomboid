require "TimedActions/ISBaseTimedAction"
require "UnifiedCarts/Core"
ISUnifiedCartTake=ISBaseTimedAction:derive("ISUnifiedCartTake")

function ISUnifiedCartTake:isValid()
    local world=self.worldObject
    if not world or not world:getSquare() then return false end
    local item=world:getItem()
    if not UnifiedCarts.isPushCart(item) then return false end
    if self.character:isDead() or self.character:getVehicle() then return false end
    local ps=self.character:getSquare()
    if not ps or not ps:canReachTo(world:getSquare()) then return false end
    if not world:getSquare():getWorldObjects():contains(world) then return false end
    if (isClient() or isServer()) and not SafeHouse.isSafehouseAllowLoot(world:getSquare(),self.character) then return false end
    return true
end

function ISUnifiedCartTake:start()
    self:setActionAnim("Loot")
    self:setAnimVariable("LootPosition","Low")
    self:setOverrideHandModels(nil,nil)
    self.character:reportEvent("EventLootItem")
end

function ISUnifiedCartTake:complete()
    if not self:isValid() then return false end
    local world=self.worldObject
    local item=world:getItem()
    local square=world:getSquare()
    forceDropHeavyItems(self.character)
    local source=item:getContainer()
    if source then source:DoRemoveItem(item) end
    square:transmitRemoveItemFromSquare(world)
    world:removeFromWorld()
    world:removeFromSquare()
    world:setSquare(nil)
    item:setWorldItem(nil)
    self.character:getInventory():AddItem(item)
    if isClient() then sendAddItemToContainer(self.character:getInventory(),item) end
    UnifiedCarts.updateModel(item)
    self.character:setPrimaryHandItem(item)
    self.character:setSecondaryHandItem(item)
    UnifiedCarts.applyCartPose(self.character)
    self.character:resetEquippedHandsModels()
    if isClient() then sendEquip(self.character) end
    ISInventoryPage.renderDirty=true
    return true
end

function ISUnifiedCartTake:perform() ISBaseTimedAction.perform(self) end
function ISUnifiedCartTake:getDuration() return self.character:isTimedActionInstant() and 1 or UnifiedCarts.Config.PickupDuration end
function ISUnifiedCartTake:new(character,worldObject)
    local o=ISBaseTimedAction.new(self,character)
    o.worldObject=worldObject
    o.maxTime=o:getDuration()
    o.stopOnWalk=true
    o.stopOnRun=true
    return o
end
