require "ZCR/Core"
require "ZCR/SpawnConfig"
ZCR.Spawns = {}
local Spawns = ZCR.Spawns
local Config = ZCR.SpawnConfig

function Spawns.buildingKey(square)
    local building = square:getBuilding()
    local def = building and building:getDef()
    if not def then return nil end
    return def:getX() .. "," .. def:getY() .. "," .. def:getW() .. "," .. def:getH()
end

function Spawns.loadSquare(square)
    if isClient() or not square then return end
    local room = square:getRoom()
    if not room or square:isOutside() or not square:isFree(false) or square:HasStairs() then return end
    local key = Spawns.buildingKey(square)
    local area = Config.area(room:getName())
    if not key or not area then return end
    local settings = SandboxVars.ZuperCarts or {}
    local history = ModData.getOrCreate("ZuperCartsRebuilt_Buildings_v2")
    local state = history[key]
    if not state then
        state = {rolled={}, spawned={}}
        -- Retain all prior cart/trolley attempts (including failed rolls).
        -- The new dolly can still be discovered in an existing world's buildings.
        local old = ModData.getOrCreate("ZuperCartsRebuilt_Buildings_v1")
        local oldCarts = ModData.getOrCreate("ZuperCarts_BuildingsWithCarts")
        local oldTrolleys = ModData.getOrCreate("ZuperCarts_BuildingsWithTrolleys")
        if old[key] or oldCarts[key] or oldTrolleys[key] then
            state.spawned.Carts = true
            state.spawned.Trolleys = true
        end
        history[key] = state
    end
    local objects = square:getWorldObjects()
    for i = 0, objects:size() - 1 do
        local kind = ZCR.cartKind(objects:get(i):getItem())
        if kind then state.spawned[kind] = true end
    end
    for index, kind in ipairs(Config.kinds) do
        local attempt = kind .. ":" .. area
        local chance = Config.chance(settings, kind, area)
        if chance > 0 and not state.spawned[kind] and not state.rolled[attempt] then
            -- One roll per type/location category, with at most one of each type
            -- in a building. Failed attempts are never rerolled on square reload.
            state.rolled[attempt] = true
            if ZombRand(10000) < chance * 100 then
                local itemType = "TMC.CartContainer"
                if kind == "Dollies" then itemType = "TMC.DollyContainer" end
                if kind == "Trolleys" then
                    local colors = {"", "Blue", "Gray", "Green", "Red"}
                    itemType = "TMC.TrolleyContainer" .. colors[ZombRand(#colors) + 1]
                end
                local item = instanceItem(itemType)
                if item then
                    -- Distinct floor offsets keep simultaneous spawns selectable.
                    local placed = square:AddWorldInventoryItem(item, 0.2 * index, 0.25 * index, 0)
                    if placed then state.spawned[kind] = true end
                else
                    print("[ZuperCartsRebuilt] Cannot instantiate " .. itemType)
                end
            end
        end
    end
end
Events.LoadGridsquare.Add(Spawns.loadSquare)
