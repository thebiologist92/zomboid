require "UnifiedCarts/Core"

local ok, err = UnifiedCarts.registerCart("UnifiedCarts.ShoppingCart", {
    name = "Shopping Cart",
    description = "A metal shopping cart for hauling supplies.",
    capacity = 50,
    weight = 8,
    weightReduction = 95,
    runSpeedModifier = 0.90,
    movementMode = "push",

    visualModels = {
        empty = "UnifiedShoppingCartModel",
        partial = "UnifiedShoppingCartPartialModel",
        full = "UnifiedShoppingCartFullModel",
    },

    spawnRooms = {
        supermarket = 35,
        gigamart = 35,
        grocery = 35,
        grocerystorage = 25,
        departmentstore = 20,
    },
})

if not ok then
    error("[UnifiedCarts] ShoppingCart registration failed: " .. tostring(err))
end
