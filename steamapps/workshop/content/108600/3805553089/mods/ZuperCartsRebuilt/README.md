# ZuperCarts Rebuilt — 0.2.0 development build

For Project Zomboid 42.20.4. Mod ID: `ZuperCartsRebuilt`.

## Changes

- Dolly rendering revision: fresh, explicitly named GLB meshes for empty and
  loaded states, separate held and ground model definitions, a centered ground
  pivot with clearance, and scale 0.26 instead of 0.30. This follows a client log
  showing failure to load the old empty mesh. Fully exit the game before testing;
  returning to the main menu can retain failed assets in the current process.

- Adds an original orange, two-wheel **Hand Dolly** with empty and loaded models,
  its own inventory icon, and natural garage spawns. Item: `TMC.DollyContainer`.
- Keeps the grocery cart and all five platform trolley colors and legacy IDs.
- Adds independent switches for each type, plus a switch for each type in each
  location: **Stores**, **Warehouses / factories**, **Garages**, **Other storage**.
- Adds **Rare**, **Default**, **Common**, and **Custom** spawn presets. Rare uses
  half the default percentages; Common doubles them. Custom uses the individual
  percentage fields (0–100, including decimals). Switches apply to all presets.
- Each type now rolls independently: a grocery cart no longer consumes the
  trolley or dolly's opportunity in a newly processed building.

## Default chances

| Type | Stores | Warehouses / factories | Garages | Other storage |
|---|---:|---:|---:|---:|
| Grocery cart | 35% | 15% | 0% | 10% |
| Platform trolley | 15% | 30% | 10% | 20% |
| Hand dolly | 5% | 20% | 30% | 15% |

These are independent chances per type and location category within a building,
not percentages of loot containers. One roll occurs at the first eligible free
interior floor square for that category. A building can contain at most one
naturally spawned item of each type (three total); a successful spawn prevents
that type from rolling in another category there. Failed rolls persist through
reloads. A failed store roll can still be followed by a storage-room roll.

Rooms are classified using the game's room names, not the building's appearance.
Garages include `garage`, `garagestorage`, `garage_ranger`, `firegarage`,
`policegarage`, and `mechanic`. Custom maps with different room names may need
additional mappings. Outdoor parking lots and ordinary bedrooms/kitchens do not
qualify. Items appear on the floor, not inside shelves or crates.

## Settings and installation

Restart the game/server after replacing the mod files. Enable **ZuperCarts
Rebuilt [42.20]** and disable the old fork (`B42_TMC_Trolley`). Keep the same mod
ID when updating an existing server. Multiplayer clients need the same version.

In the sandbox settings, choose the preset under **ZuperCarts: General**.
Each type has its own ZuperCarts page with an overall switch, four location
switches, and four custom percentage fields. To use your own percentages, select
**Custom** first. For example, only dollies in garages: turn off grocery carts
and trolleys; leave dollies enabled; turn off the dolly's other three locations;
set its garage chance as desired.

For a quick test in a fresh sandbox, set Custom and all desired chances to 100%.
Explore a qualifying building or use the debug item list to find **Hand Dolly**.
Right-click **Push** / **Release**, or use **G** nearby (configurable in Mod
Options). Items keep their contents, name, favorite status, and identity.
Base cargo capacity: **Hand Dolly 25**, **Grocery Cart 32**, **Platform Trolley 37**.
All three types require both hands, weigh 13, and use 100% container weight reduction while equipped. Carts/dollies cannot be nested in each other.

## Existing worlds

The update does not delete or replace existing items or reset spawn records.
Buildings recorded by version 0.1.0 or the original fork retain their old
cart/trolley history, including failed attempts. The new dolly gets its own
opportunity in those buildings when an eligible square next loads. If you are
already standing in a loaded area, revisit it after its squares reload.
Changing percentages does not reroll an already attempted type/location. Turning
off a type stops future natural spawns; it does not remove existing items.

## Validation and remaining checks

See `validation` for the actual automated and engine results. Regression checks
cover all 14 item variants, all 12 type/location combinations, preset multipliers,
0/100/fractional percentages, per-building limits, persistent failures, migration,
server-only spawning, safe pickup, cargo preservation and nesting prevention.
Both revised dolly GLB mesh files are accepted by the installed game's JAssimp
importer with normals and texture coordinates.

The dolly reuses the existing two-hand pushing animation. Its hand placement,
ground alignment and movement still need visual testing in-game, as does
two-client multiplayer behavior. Model preview images are renders of the asset,
not gameplay screenshots. A dedicated-server test does not validate rendering.
Existing retained assets may report the previously observed `Body` bone warning.

## Credits

Original ZuperCart: **iBrRus and Troy Mc'Clure**. B42 fork: **Viruana**, Workshop
3433203442. Original cart/trolley models, textures and animations retain those
credits. The new dolly geometry, palette and icon were authored for this update;
the reproducible generator is included in the project tools.

No redistribution license was found with the original download. Its permission
status is unchanged by this update. This work prepares local files and an upload
folder; it does not publish a Steam Workshop update automatically.

The supplied ZuperCarts artwork is installed as the mod poster and prepared as the Workshop preview.

