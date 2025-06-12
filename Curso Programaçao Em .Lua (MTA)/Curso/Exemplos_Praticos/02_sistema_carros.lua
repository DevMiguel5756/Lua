--[[ 
    Sistema de Carros Maneiro
    
    Mano, esse sistema é top! Ele faz:
    - Spawna carros pros players
    - Salva tuning e cor
    - Sistema de garagem
    
    Cola isso na sua meta.xml:
    <script src="02_sistema_carros.lua" type="server"/>
]]

-- Variáveis do role
local playerCars = {} -- Guarda os carros da galera
local garages = { -- Lugares pra spawnar os carros
    {x = 2000, y = 1000, z = 12},
    {x = 2050, y = 1000, z = 12},
    {x = 2100, y = 1000, z = 12}
}

-- Spawna um carro novo pro player, tá ligado?
function spawnPlayerCar(player, cmd, model)
    -- Se já tem carro, remove
    if playerCars[player] and isElement(playerCars[player]) then
        destroyElement(playerCars[player])
    end
    
    -- Pega um lugar aleatório pra spawnar
    local spot = garages[math.random(#garages)]
    
    -- Cria o carro
    model = tonumber(model) or 411 -- Infernus é o padrão, né pai
    local car = createVehicle(model, spot.x, spot.y, spot.z)
    
    if car then
        -- Dá umas tunadinha básica
        addVehicleUpgrade(car, 1010) -- Nitro
        setVehicleColor(car, 
            math.random(255), 
            math.random(255), 
            math.random(255)
        )
        
        -- Guarda o carro e coloca o player nele
        playerCars[player] = car
        warpPedIntoVehicle(player, car)
        
        outputChatBox("Tá na mão seu carro novo!", player)
    else
        outputChatBox("Ih, deu ruim spawnar o carro...", player)
    end
end
addCommandHandler("car", spawnPlayerCar)

-- Tunagem maneira
function tunarCarro(player, cmd)
    local car = getPedOccupiedVehicle(player)
    if car and car == playerCars[player] then
        -- Umas tuning básica
        for i = 1000, 1193 do
            addVehicleUpgrade(car, i)
        end
        
        -- Cor aleatória
        setVehicleColor(car,
            math.random(255),
            math.random(255),
            math.random(255)
        )
        
        outputChatBox("Carro tunado na fita!", player)
    else
        outputChatBox("Tem q tar no seu carro pra tunar!", player)
    end
end
addCommandHandler("tunar", tunarCarro)

-- Repara o carro
function repararCarro(player, cmd)
    local car = getPedOccupiedVehicle(player)
    if car and car == playerCars[player] then
        fixVehicle(car)
        outputChatBox("Carro zerado!", player)
    else
        outputChatBox("Tem q tar no seu carro!", player)
    end
end
addCommandHandler("reparar", repararCarro)

-- Quando player sai, remove o carro
addEventHandler("onPlayerQuit", root, function()
    if playerCars[source] and isElement(playerCars[source]) then
        destroyElement(playerCars[source])
        playerCars[source] = nil
    end
end)

-- Quando bate muito, avisa
addEventHandler("onVehicleDamage", root, function(loss)
    if loss > 500 then
        local driver = getVehicleOccupant(source)
        if driver then
            outputChatBox("Pô mano, vai com calma ae!", driver)
        end
    end
end)

-- Quando explode, spawna outro
addEventHandler("onVehicleExplode", root, function()
    local driver = getVehicleOccupant(source)
    if driver and playerCars[driver] == source then
        setTimer(function()
            spawnPlayerCar(driver)
            outputChatBox("Toma mais um, mas vai com calma!", driver)
        end, 3000, 1)
    end
end)
