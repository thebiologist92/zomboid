require "Items/ZuperCartsRoomDefs"
ZCR = ZCR or {}
ZCR.SpawnConfig = {}
local Config = ZCR.SpawnConfig
Config.kinds = {"Carts", "Trolleys", "Dollies"}
Config.areas = {"Stores", "Warehouses", "Garages", "Storage"}
Config.defaults = {
    Carts = {Stores=35, Warehouses=15, Garages=0, Storage=10},
    Trolleys = {Stores=15, Warehouses=30, Garages=10, Storage=20},
    Dollies = {Stores=5, Warehouses=20, Garages=30, Storage=15},
}
local garages = {garage=true, garagestorage=true, garage_ranger=true,
    firegarage=true, policegarage=true, mechanic=true, mechanics=true,
    mechanicshop=true, autoshop=true}
local warehouses = {warehouse=true, loggingwarehouse=true, factory=true,
    industry=true, construction=true, workshop=true}
local storage = {storage=true, storageunit=true, coldroom=true, pantry=true,
    woodshed=true, dinerbackroom=true, gigamartkitchen=true}

-- Restrict matching to known commercial/storage rooms, not arbitrary house rooms.
function Config.area(roomName)
    if not roomName then return nil end
    if garages[roomName] then return "Garages" end
    if warehouses[roomName] then return "Warehouses" end
    local known = ZuperCarts.RoomDefs.CartRooms[roomName]
        or ZuperCarts.RoomDefs.TrolleyRooms[roomName]
    if not known then return nil end
    if string.find(roomName, "factory", 1, true)
        or string.find(roomName, "shipping", 1, true)
        or roomName == "sodabottling" then return "Warehouses" end
    if storage[roomName] or string.find(roomName, "storage", 1, true)
        or string.find(roomName, "kitchen", 1, true) then return "Storage" end
    return "Stores"
end

function Config.chance(settings, kind, area)
    settings = settings or {}
    if settings["Spawn" .. kind] == false or settings[kind .. area] == false then return 0 end
    local base = Config.defaults[kind][area]
    local preset = tonumber(settings.SpawnPreset) or 2
    if preset == 4 then
        local value = tonumber(settings[kind .. area .. "Chance"])
        if value == nil or value ~= value then value = base end
        return math.max(0, math.min(100, value))
    end
    local multiplier = preset == 1 and 0.5 or (preset == 3 and 2 or 1)
    return math.min(100, base * multiplier)
end
return Config
