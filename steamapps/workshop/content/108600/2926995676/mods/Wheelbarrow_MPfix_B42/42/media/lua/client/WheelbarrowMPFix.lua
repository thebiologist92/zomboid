-- Wheelbarrow MP Fix
-- Parche para "Wheelbarrow from Hydrocraft v2" (Workshop 2926995676) en multijugador B42.
--
-- Fallo 1: "Push/Empujar" quitaba la carretilla del suelo avisando al servidor, pero
-- la metia en el inventario SOLO en el cliente (PFGPushAction:perform). El servidor la
-- daba por destruida: no se podia soltar ni guardar (la barra nunca terminaba) y
-- desaparecia al reconectar.
-- Arreglo: "Push" lanza WheelbarrowMPFixPushAction (shared/), que el servidor valida y
-- ejecuta: quita la carretilla del suelo y la pone en ambas manos. No usa la
-- transferencia normal al inventario porque la carretilla (peso 20) no cabe y el juego
-- la rechazaba sin avisar.
--
-- Fallo 2: el mod subia la capacidad a 180 SOLO en el cliente; el servidor mantiene la
-- del script, asi que meter mas de 50 dejaba la transferencia rechazada/colgada.
-- Arreglo: las comprobaciones de la carretilla vuelven a usar la capacidad real.
--
-- Fallo 3 (reportado con RV Interiors): ItemContainer:setCapacity() es una escritura
-- PERMANENTE sobre el contenedor, no algo temporal para la comprobacion. El mod original
-- escribia 180 y este parche escribia 50 en cada isValid/canPutIn, pisando el valor que
-- el motor le haya puesto a la carretilla segun donde este (B42 usa limites distintos
-- para bolsas y para contenedores dentro de vehiculos, ver el comentario "hard coded b42
-- 50 bags, 1000 vehicle" en Carpentry42.txt). Al entrar al interior de un vehiculo con
-- RV Interiors el contexto cambia y la capacidad que habiamos forzado se quedaba fijada
-- por debajo de la que tocaba, y ademas la UI solo refresca el numero cuando cambia
-- (ISInventoryPage.lua:484), asi que se quedaba viendo el valor reducido.
-- Arreglo: no escribir capacidad nunca. Basta con neutralizar el bypass del mod original
-- para que la comprobacion vanilla use la capacidad real del contenedor, que ya respeta
-- el script, el rasgo "Organizado" (getEffectiveCapacity) y el contexto del motor.
-- Solo se deshace la escritura del mod original si se detecta su valor inflado exacto.
--
-- Todo se aplica en OnGameStart, cuando el mod original ya ha cargado, sin depender
-- del orden de carga de los ficheros.

require "WheelbarrowMPFix_PushAction"

local MOD_INFLATED_CAPACITY = 180   -- b41_capacity que escribe WheelbarrowB42limit.lua

local function isWheelbarrowContainer(container)
    return container ~= nil and container.getType ~= nil
        and PFGMenu ~= nil and PFGMenu.typesTable ~= nil
        and PFGMenu.typesTable[container:getType()] == true
end

-- Capacidad declarada en el script del item, que es la que aplica el servidor.
local function scriptCapacity(container)
    local item = container.getContainingItem and container:getContainingItem()
    local script = item and item.getScriptItem and item:getScriptItem()
    if script and script.getCapacity then
        local capacity = script:getCapacity()
        if capacity and capacity > 0 then return capacity end
    end
    return nil
end

-- El mod original inflaba la capacidad a 180 de forma permanente. Si ya lo hizo (por
-- ejemplo otro mod llamo a su version de isValid saltandose la nuestra), se devuelve al
-- valor del script. Cualquier otro valor se respeta: puede haberlo puesto el motor.
local function undoInflatedCapacity(container)
    if container:getCapacity() ~= MOD_INFLATED_CAPACITY then return end
    local capacity = scriptCapacity(container)
    if capacity and capacity ~= MOD_INFLATED_CAPACITY then
        container:setCapacity(capacity)
    end
end

-- Ejecuta la comprobacion del mod original como si la carretilla no fuera especial,
-- de modo que su envoltorio cae en la comprobacion vanilla (capacidad real).
local function withoutBypass(fn, obj)
    local saved = PFGMenu.typesTable
    PFGMenu.typesTable = {}
    local ok, result = pcall(fn, obj)
    PFGMenu.typesTable = saved
    if not ok then error(result) end
    return result
end

local function pushFromGround(worldobjects, player, worldItem)
    local item = worldItem and worldItem.getItem and worldItem:getItem()
    local square = worldItem and worldItem.getSquare and worldItem:getSquare()
    if not item or not square then return end
    local playerObj = getSpecificPlayer(player)
    local currentSquare = playerObj and playerObj:getCurrentSquare()
    if not currentSquare then return end

    if not AdjacentFreeTileFinder.isTileOrAdjacent(currentSquare, square) then
        local adjacent = AdjacentFreeTileFinder.Find(square, playerObj)
        if not adjacent then return end
        ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, adjacent))
    end
    ISTimedActionQueue.add(WheelbarrowMPFixPushAction:new(playerObj, square, item:getID()))
end

local function patchCapacityChecks()
    local modIsValid = ISInventoryTransferAction.isValid
    function ISInventoryTransferAction:isValid()
        if isWheelbarrowContainer(self.destContainer) then
            undoInflatedCapacity(self.destContainer)
            return withoutBypass(modIsValid, self)
        end
        return modIsValid(self)
    end

    local modCanPutIn = ISInventoryPane.canPutIn
    function ISInventoryPane:canPutIn()
        if isWheelbarrowContainer(self.inventory) then
            undoInflatedCapacity(self.inventory)
            return withoutBypass(modCanPutIn, self)
        end
        return modCanPutIn(self)
    end
end

local patched = false
local function applyPatch()
    if patched then return end
    if not PFGMenu then
        print("[WheelbarrowMPFix] PFGMenu no encontrado: el mod de la carretilla no esta activo, no se aplica nada")
        return
    end
    patched = true
    -- El menu del mod llama a PFGMenu.equipCart al construirse y desde pushCart,
    -- asi que basta con sustituir la funcion.
    PFGMenu.equipCart = pushFromGround
    patchCapacityChecks()
    print("[WheelbarrowMPFix] parche aplicado")
end

Events.OnGameStart.Add(applyPatch)
