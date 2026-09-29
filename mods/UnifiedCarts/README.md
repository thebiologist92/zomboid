# Unified Carts - Proof of Concept

Build 42.20 proof-of-concept framework for pushable and pullable carts.

Current implementation: a metal supermarket shopping cart registered through the unified cart API.

The framework contains no durability, condition, repair, breaking, or destruction system. It uses the existing SaucedCarts shopping-cart mesh/texture and cart animation assets as references/assets and is otherwise independent of SaucedCarts and ZuperCarts.

The registry already has a movementMode field (`push`/`pull`) so the future pull system can be added without duplicating cart definitions.