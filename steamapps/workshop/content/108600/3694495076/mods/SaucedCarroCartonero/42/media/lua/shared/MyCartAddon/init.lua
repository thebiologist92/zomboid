-- ============================================================================
-- SaucedTrolley/init.lua
-- ============================================================================
-- PURPOSE: Registers custom cart types with SaucedCarts.
--          This file runs on both client and server.
-- ============================================================================

local function registerCarts()
    if not SaucedCarts or not SaucedCarts.registerCart then
        print("[SaucedTrolley] WARNING: SaucedCarts not loaded yet, queueing registration")
        SaucedCarts = SaucedCarts or {}
        SaucedCarts._pendingRegistrations = SaucedCarts._pendingRegistrations or {}
        table.insert(SaucedCarts._pendingRegistrations, {
            fullType = "SaucedCarroCartonero.CarroCartonero",
            data = {
                name = "Carro Cartonero",
                description = "Carro armado para cartonear por la ciudad.",
                capacity = 70,
                weightReduction = 90,
                runSpeedModifier = 0.55,
                conditionMax = 100,
                baseWeight = 15.0,
                repairItem = "Base.ScrapMetal",
                repairAmount = 10,
                spawnRooms = {
                    -- High priority (15-25% chance) - Primary warehouse locations
                    { room = "warehouse", chance = 30 },
                    { room = "storageunit", chance = 30 },
                    { room = "gardenstore", chance = 25 },
                    { room = "toolstore", chance = 25 },
                    -- Medium priority (8-15% chance) - Secondary retail/storage
                    { room = "gigamart", chance = 15 },
                    { room = "grocerystorage", chance = 15 },
                    { room = "bookstore", chance = 5 },
                    { room = "clothingstore", chance = 10 },
                    { room = "electronicsstore", chance = 12 },
                    { room = "sportstore", chance = 10 },
                    { room = "mall", chance = 12 },
                    { room = "grocery", chance = 10 },
                    { room = "supermarket", chance = 10 },
                    { room = "departmentstore", chance = 15 },
                    -- Low priority (3-8% chance) - Uncommon locations
                    { room = "parkinglot", chance = 46 },
                    { room = "conveniencestore", chance = 5 },
                    { room = "cornerstore", chance = 5 },
                    { room = "pawnshop", chance = 3 },
                    { room = "lobby", chance = 3 },
                },
                spawnWeight = 1,
                visualModels = {
                    empty = "CarroCartonero",
                    partial = "CarroCartoneroPartial",
                    full = "CarroCartoneroFull",
                },
            }
        })
        return
    end

    local success, err = SaucedCarts.registerCart("SaucedCarroCartonero.CarroCartonero", {
        name = "Carro Cartonero",
        description = "Carro armado para cartonear por la ciudad.",
        capacity = 70,
        weightReduction = 90,
        runSpeedModifier = 0.55,
        conditionMax = 100,
        baseWeight = 15.0,
        repairItem = "Base.ScrapMetal",
        repairAmount = 10,
        spawnRooms = {
            -- High priority (15-25% chance) - Primary warehouse locations
            { room = "warehouse", chance = 30 },
            { room = "storageunit", chance = 30 },
            { room = "gardenstore", chance = 25 },
            { room = "toolstore", chance = 25 },
            -- Medium priority (8-15% chance) - Secondary retail/storage
            { room = "gigamart", chance = 15 },
            { room = "grocerystorage", chance = 15 },
            { room = "bookstore", chance = 5 },
            { room = "clothingstore", chance = 10 },
            { room = "electronicsstore", chance = 12 },
            { room = "sportstore", chance = 10 },
            { room = "mall", chance = 12 },
            { room = "grocery", chance = 10 },
            { room = "supermarket", chance = 10 },
            { room = "departmentstore", chance = 15 },
            -- Low priority (3-8% chance) - Uncommon locations
            { room = "parkinglot", chance = 46 },
            { room = "conveniencestore", chance = 5 },
            { room = "cornerstore", chance = 5 },
            { room = "pawnshop", chance = 3 },
            { room = "lobby", chance = 3 },
        },
        spawnWeight = 1,
        visualModels = {
            empty = "CarroCartonero",
            partial = "CarroCartoneroPartial",
            full = "CarroCartoneroFull",
        },
    })

    if success then
        print("[SaucedCarroCartonero] Successfully registered CarroCartonero")
    else
        print("[SaucedCarroCartonero] ERROR: Failed to register CarroCartonero: " .. tostring(err))
    end
end

registerCarts()

print("[SaucedCarroCartonero] Loaded")
