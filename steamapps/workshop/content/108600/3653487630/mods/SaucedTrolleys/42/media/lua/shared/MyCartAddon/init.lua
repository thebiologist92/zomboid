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
            fullType = "SaucedTrolley.TrolleyCart",
            data = {
                name = "Trolley Cart",
                description = "A handy trolley cart for hauling goods.",
                capacity = 55,
                weightReduction = 90,
                runSpeedModifier = 0.75,
                conditionMax = 100,
                baseWeight = 5.0,
                repairItem = "Base.ScrapMetal",
                repairAmount = 10,
                spawnRooms = {
                    -- High priority (15-25% chance) - Primary warehouse locations
                    { room = "warehouse", chance = 50 },
                    { room = "storageunit", chance = 30 },
                    { room = "gardenstore", chance = 25 },
                    { room = "toolstore", chance = 25 },
                    -- Medium priority (8-15% chance) - Secondary retail/storage
                    { room = "gigamart", chance = 15 },
                    { room = "grocerystorage", chance = 15 },
                    { room = "bookstore", chance = 10 },
                    { room = "clothingstore", chance = 10 },
                    { room = "electronicsstore", chance = 12 },
                    { room = "sportstore", chance = 10 },
                    { room = "mall", chance = 12 },
                    { room = "grocery", chance = 10 },
                    { room = "supermarket", chance = 10 },
                    { room = "departmentstore", chance = 15 },
                    -- Low priority (3-8% chance) - Uncommon locations
                    { room = "parkinglot", chance = 6 },
                    { room = "conveniencestore", chance = 5 },
                    { room = "cornerstore", chance = 5 },
                    { room = "pawnshop", chance = 3 },
                    { room = "lobby", chance = 3 },
                },
                spawnWeight = 1,
                visualModels = {
                    empty = "TrolleyCart",
                    partial = "TrolleyCartPartial",
                    full = "TrolleyCartFull",
                },
            }
        })
        return
    end

    local success, err = SaucedCarts.registerCart("SaucedTrolley.TrolleyCart", {
        name = "Trolley Cart",
        description = "A handy trolley cart for hauling goods.",
        capacity = 55,
        weightReduction = 90,
        runSpeedModifier = 0.75,
        conditionMax = 100,
        baseWeight = 5.0,
        repairItem = "Base.ScrapMetal",
        repairAmount = 10,
        spawnRooms = {
            -- High priority (15-25% chance) - Primary warehouse locations
            { room = "warehouse", chance = 50 },
            { room = "storageunit", chance = 30 },
            { room = "gardenstore", chance = 25 },
            { room = "toolstore", chance = 25 },
            -- Medium priority (8-15% chance) - Secondary retail/storage
            { room = "gigamart", chance = 15 },
            { room = "grocerystorage", chance = 15 },
            { room = "bookstore", chance = 10 },
            { room = "clothingstore", chance = 10 },
            { room = "electronicsstore", chance = 12 },
            { room = "sportstore", chance = 10 },
            { room = "mall", chance = 12 },
            { room = "grocery", chance = 10 },
            { room = "supermarket", chance = 10 },
            { room = "departmentstore", chance = 15 },
            -- Low priority (3-8% chance) - Uncommon locations
            { room = "parkinglot", chance = 6 },
            { room = "conveniencestore", chance = 5 },
            { room = "cornerstore", chance = 5 },
            { room = "pawnshop", chance = 3 },
            { room = "lobby", chance = 3 },
        },
        spawnWeight = 1,
        visualModels = {
            empty = "TrolleyCart",
            partial = "TrolleyCartPartial",
            full = "TrolleyCartFull",
        },
    })

    if success then
        print("[SaucedTrolley] Successfully registered TrolleyCart")
    else
        print("[SaucedTrolley] ERROR: Failed to register TrolleyCart: " .. tostring(err))
    end
end

registerCarts()

print("[SaucedTrolley] Loaded")
