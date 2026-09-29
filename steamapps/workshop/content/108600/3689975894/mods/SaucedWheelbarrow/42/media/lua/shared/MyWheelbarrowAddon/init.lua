-- ============================================================================
-- SaucedWheelbarrow/init.lua
-- ============================================================================
-- PURPOSE: Registers custom cart types with SaucedCarts.
--          This file runs on both client and server.
-- ============================================================================

local function registerCart1()
    if not SaucedCarts or not SaucedCarts.registerCart then
        print("[SaucedTrolley] WARNING: SaucedCarts not loaded yet, queueing registration")
        SaucedCarts = SaucedCarts or {}
        SaucedCarts._pendingRegistrations = SaucedCarts._pendingRegistrations or {}
        table.insert(SaucedCarts._pendingRegistrations, {
            fullType = "SaucedWheelbarrow.WheelbarrowWood",
            data = {
                name = "Wooden Wheelbarrow",
                description = "A handy wooden wheelbarrow for hauling stuff.",
                capacity = 30,
                weightReduction = 75,
                runSpeedModifier = 0.70,
                conditionMax = 80,
                baseWeight = 5.0,
                repairItem = "Base.UnusableWood",
                repairAmount = 10,
                spawnRooms = {
                    { room = "gardenstore", chance = 25 },
                    { room = "toolstore", chance = 15 },
                    { room = "farmstorage", chance = 25 },
                    { room = "garagestorage", chance = 7 },
                    { room = "shed", chance = 7 },
                },
                spawnWeight = 1,
                visualModels = {
                    empty = "WheelbarrowWood",
                    partial = "WheelbarrowWood",
                    full = "WheelbarrowWood",
                },
            }
        })
        return
    end

    local success, err = SaucedCarts.registerCart("SaucedWheelbarrow.WheelbarrowWood", {
                name = "Wooden Wheelbarrow",
                description = "A handy wooden wheelbarrow for hauling stuff.",
                capacity = 30,
                weightReduction = 75,
                runSpeedModifier = 0.70,
                conditionMax = 80,
                baseWeight = 5.0,
                repairItem = "Base.UnusableWood",
                repairAmount = 10,
                spawnRooms = {
                    { room = "gardenstore", chance = 25 },
                    { room = "toolstore", chance = 15 },
                    { room = "farmstorage", chance = 25 },
                    { room = "garagestorage", chance = 7 },
                    { room = "shed", chance = 7 },
                },
                spawnWeight = 1,
                visualModels = {
                    empty = "WheelbarrowWood",
                    partial = "WheelbarrowWood",
                    full = "WheelbarrowWood",
                },

    })

    if success then
        print("[SaucedWheelbarrow] Successfully registered SaucedWheelbarrow.WheelbarrowWood")
    else
        print("[SaucedWheelbarrow] ERROR: Failed to register SaucedWheelbarrow.WheelbarrowWood: " .. tostring(err))
    end
end

local function registerCart2()
    if not SaucedCarts or not SaucedCarts.registerCart then
        print("[SaucedTrolley] WARNING: SaucedCarts not loaded yet, queueing registration")
        SaucedCarts = SaucedCarts or {}
        SaucedCarts._pendingRegistrations = SaucedCarts._pendingRegistrations or {}
        table.insert(SaucedCarts._pendingRegistrations, {
            fullType = "SaucedWheelbarrow.WheelbarrowMetal",
            data = {
                name = "Metal Wheelbarrow",
                description = "A handy metal wheelbarrow for hauling stuff.",
                capacity = 40,
                weightReduction = 85,
                runSpeedModifier = 0.75,
                conditionMax = 120,
                baseWeight = 4.0,
                repairItem = "Base.ScrapMetal",
                repairAmount = 10,
                spawnRooms = {
                    { room = "gardenstore", chance = 25 },
                    { room = "toolstore", chance = 15 },
                    { room = "farmstorage", chance = 25 },
                    { room = "garagestorage", chance = 7 },
                    { room = "shed", chance = 7 },
                },
                spawnWeight = 1,
                visualModels = {
                    empty = "WheelbarrowMetal",
                    partial = "WheelbarrowMetal",
                    full = "WheelbarrowMetal",
                },
            }
        })
        return
    end
    local success, err = SaucedCarts.registerCart("SaucedWheelbarrow.WheelbarrowMetal", {
                name = "Metal Wheelbarrow",
                description = "A handy metal wheelbarrow for hauling stuff.",
                capacity = 40,
                weightReduction = 85,
                runSpeedModifier = 0.75,
                conditionMax = 120,
                baseWeight = 4.0,
                repairItem = "Base.ScrapMetal",
                repairAmount = 10,
                spawnRooms = {
                    { room = "gardenstore", chance = 25 },
                    { room = "toolstore", chance = 15 },
                    { room = "farmstorage", chance = 25 },
                    { room = "garagestorage", chance = 7 },
                    { room = "shed", chance = 7 },
                },
                spawnWeight = 1,
                visualModels = {
                    empty = "WheelbarrowMetal",
                    partial = "WheelbarrowMetal",
                    full = "WheelbarrowMetal",
                },

    })

    if success then
        print("[SaucedWheelbarrow] Successfully registered SaucedWheelbarrow.WheelbarrowMetal")
    else
        print("[SaucedWheelbarrow] ERROR: Failed to register SaucedWheelbarrow.WheelbarrowMetal: " .. tostring(err))
    end
end


registerCart1()
registerCart2()

print("[SaucedWheelbarrow] Loaded")
