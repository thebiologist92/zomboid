require "UnifiedCarts/Core"
require "UnifiedCarts/CartData"

UnifiedCarts.Server = UnifiedCarts.Server or {}

local MODDATA_KEY = "UnifiedCarts_Buildings_v1"

local function buildingKey(square)
    local building = square and square:getBuilding()
    local def = building and building:getDef()
    if not def then return nil end

    return table.concat({
        tostring(def:getX()),
        tostring(def:getY()),
        tostring(def:getW()),
        tostring(def:getH())
    }, ",")
end

local function buildingHasCart(building, fullType)
    if not building then return false end

    local rooms = building:getRooms()
    if not rooms then return false end

    for i = 0, rooms:size() - 1 do
        local room = rooms:get(i)
        local squares = room:getSquares()

        if squares then
            for j = 0, squares:size() - 1 do
                local square = squares:get(j)
                local objects = square:getWorldObjects()

                if objects then
                    for k = 0, objects:size() - 1 do
                        local object = objects:get(k)
                        if instanceof(object, "IsoWorldInventoryObject") then
                            local item = object:getItem()
                            if item and item:getFullType() == fullType then
                                return true
                            end
                        end
                    end
                end
            end
        end
    end

    return false
end

local function trySpawn(square)
    if isClient() or not square then return end

    local settings = SandboxVars.UnifiedCarts
    if settings and settings.EnableNaturalSpawns == false then return end

    local room = square:getRoom()
    if not room then return end

    local data = UnifiedCarts.CartTypes["UnifiedCarts.ShoppingCart"]
    if not data then return end

    local roomChance = data.spawnRooms[room:getName()]
    if not roomChance then return end

    local building = square:getBuilding()
    local key = buildingKey(square)
    if not building or not key then return end

    local state = ModData.getOrCreate(MODDATA_KEY)
    state.rolled = state.rolled or {}
    state.spawned = state.spawned or {}

    if state.spawned[key] then return end
    if state.rolled[key] then return end

    state.rolled[key] = true

    if buildingHasCart(building, "UnifiedCarts.ShoppingCart") then
        state.spawned[key] = true
        return
    end

    local chance = roomChance
    if settings and settings.ShoppingCartSpawnChance ~= nil then
        chance = settings.ShoppingCartSpawnChance
    end

    if ZombRand(10000) >= chance * 100 then return end

    local item = instanceItem("UnifiedCarts.ShoppingCart")
    if not item then return end

    UnifiedCarts.updateModel(item)

    local world = square:AddWorldInventoryItem(item, 0.2, 0.25, 0)
    if world then
        state.spawned[key] = true
    end
end

Events.LoadGridsquare.Add(trySpawn)
