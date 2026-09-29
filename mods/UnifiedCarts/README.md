# Unified Carts - Proof of Concept

Build 42.20 proof-of-concept framework for pushable and pullable carts.

Current implementation: a metal supermarket shopping cart registered through the unified cart API.

The framework code contains no durability, condition, repair, breaking, or destruction system.

For this proof of concept, the mod **requires SaucedCarts only so it can reuse its existing shopping-cart mesh, texture and character animation assets**. The Unified Carts gameplay framework itself does not call SaucedCarts gameplay APIs and uses its own registry, item type, animation-state names, context actions and cart logic.

The registry already has a movementMode field (push/pull) so the future pull system can be added without duplicating cart definitions.

Install/enable SaucedCarts alongside Unified Carts for this POC build.
