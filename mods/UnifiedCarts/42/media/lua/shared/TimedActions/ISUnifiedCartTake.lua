require "TimedActions/ISBaseTimedAction"
require "UnifiedCarts/Core"

ISUnifiedCartTake = ISBaseTimedAction:derive("ISUnifiedCartTake")
ISUnifiedCartTake.Type = "ISUnifiedCartTake"

function ISUnifiedCartTake:isValid()
    if self.completed then return true end
    if not self.character or self.character:isDead() or self.character:getVehicle() then return false end

    local world = self:findWorldObject()
    if not world then return false end

    local square = world:getSquare()
    if not square then return false end

    local playerSquare = self.character:getSquare()
    if playerSquare and not playerSquare:canReachTo(square) then return false end

    local item = world:getItem()
    return item ~= nil and UnifiedCarts.isPushCart(item)
end

function ISUnifiedCartTake:waitToStart()
    local world = self:findWorldObject()
    if world then
        self.character:faceThisObject(world)
    end
    return self.character:shouldBeTurning()
end

function ISUnifiedCartTake:update()
    local world = self:findWorldObject()
    if world then
        self.character:faceThisObject(world)
    end
    self.character:setMetabolicTarget(Metabolics.HeavyDomestic)
end

function ISUnifiedCartTake:start()
    self:setActionAnim("Loot")
    self:setAnimVariable("LootPosition", "Low")
    self:setOverrideHandModels(nil, nil)
    self.character:reportEvent("EventLootItem")
end

function ISUnifiedCartTake:complete()
    local world = self:findWorldObject()
    if not world then return false end

    local item = world:getItem()
    if not item or not UnifiedCarts.isPushCart(item) then return false end

    local square = world:getSquare()
    if not square then return false end

    -- Remove the exact world object we validated. A competing pickup therefore
    -- makes this action fail rather than creating a second copy.
    square:transmitRemoveItemFromSquare(world)
    square:removeWorldObject(world)
    item:setWorldItem(nil)

    self.character:getInventory():AddItem(item)
    sendAddItemToContainer(self.character:getInventory(), item)

    UnifiedCarts.updateModel(item)

    self.character:setPrimaryHandItem(item)
    self.character:setSecondaryHandItem(item)
    UnifiedCarts.applyCartPose(self.character)
    self.character:resetEquippedHandsModels()

    if isServer() then
        sendEquip(self.character)
    end

    ISInventoryPage.renderDirty = true
    self.completed = true
    return true
end

function ISUnifiedCartTake:perform()
    ISBaseTimedAction.perform(self)
end

function ISUnifiedCartTake:getDuration()
    if self.character:isTimedActionInstant() then return 1 end
    return UnifiedCarts.Config.PickupDuration
end

function ISUnifiedCartTake:findWorldObject()
    local square = getCell():getGridSquare(self.squareX, self.squareY, self.squareZ)
    if not square then return nil end

    local objects = square:getWorldObjects()
    if not objects then return nil end

    for i = 0, objects:size() - 1 do
        local object = objects:get(i)
        if instanceof(object, "IsoWorldInventoryObject") then
            local item = object:getItem()
            if item and item:getID() == self.itemId then
                return object
            end
        end
    end

    return nil
end

function ISUnifiedCartTake:new(character, worldObject)
    local square = worldObject and worldObject:getSquare()
    local item = worldObject and worldObject:getItem()
    if not square or not item then return nil end

    local o = ISBaseTimedAction.new(self, character)
    o.squareX = square:getX()
    o.squareY = square:getY()
    o.squareZ = square:getZ()
    o.itemId = item:getID()
    o.completed = false
    o.maxTime = o:getDuration()
    o.forceProgressBar = true
    o.stopOnWalk = true
    o.stopOnRun = true
    o.stopOnAim = true
    return o
end
