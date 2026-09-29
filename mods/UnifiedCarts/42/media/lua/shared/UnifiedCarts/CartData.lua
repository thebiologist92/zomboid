require "UnifiedCarts/Core"
local ok,err=UnifiedCarts.registerCart("UnifiedCarts.ShoppingCart",{
    name="Shopping Cart",
    description="A metal shopping cart for hauling supplies.",
    capacity=50, weightReduction=95, runSpeedModifier=0.90, movementMode="push",
    visualModels={empty="ShoppingCartModel",partial="ShoppingCartPartialModel",full="ShoppingCartFullModel"}
})
if not ok then error("[UnifiedCarts] ShoppingCart registration failed: "..tostring(err)) end
