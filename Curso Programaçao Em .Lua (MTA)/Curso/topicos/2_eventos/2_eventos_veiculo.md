# Eventos de Veículos no MTA:SA

E aí, dev! Vamo aprender tudo sobre eventos de veículos? É mais fácil do que você imagina!

## 1. Eventos Básicos de Veículos

### 1.1 Qnd Alguém Entra/Sai do Carro
```lua
-- Qnd alguém entra no carro
addEventHandler("onVehicleEnter", root, function(player, seat)
    -- player = quem entrou
    -- seat = banco que sentou (0 = motorista)
    outputChatBox("E aí, " .. getPlayerName(player) .. 
        "! Dirigindo na " .. seat .. "?")
end)

-- Qnd alguém sai do carro
addEventHandler("onVehicleExit", root, function(player, seat)
    outputChatBox("Tchau, " .. getPlayerName(player) .. 
        "! Volte sempre!")
end)
```

### 1.2 Dano no Carro
```lua
-- Qnd o carro toma dano
addEventHandler("onVehicleDamage", root, function(loss)
    -- loss = quanto de dano tomou
    local health = getElementHealth(source)
    if health < 250 then
        outputChatBox("Cuidado! Seu carro tá quase explodindo!")
    end
end)
```

## 2. Eventos de Controle

### 2.1 Controle do Carro
```lua
-- Qnd alguém tenta entrar
addEventHandler("onVehicleStartEnter", root, 
function(player, seat, jacked)
    -- jacked = true se for roubo
    if jacked then
        outputChatBox("Alguém tentou roubar seu carro!")
        cancelEvent() -- Impede o roubo
    end
end)

-- Qnd muda a velocidade
addEventHandler("onVehicleVelocityChange", root, 
function(vx, vy, vz)
    local speed = math.sqrt(vx*vx + vy*vy + vz*vz) * 180
    if speed > 200 then
        outputChatBox("Vai com calma aí, Fast & Furious!")
    end
end)
```

### 2.2 Customização do Carro
```lua
-- Qnd alguém modifica o carro
addEventHandler("onVehicleModified", root, function(component)
    outputChatBox("Nova peça instalada: " .. component)
end)

-- Qnd muda a cor
addEventHandler("onVehicleRespray", root, 
function(r1, g1, b1, r2, g2, b2)
    outputChatBox("Carro repintado! Ficou estilo!")
end)
```

## 3. Eventos Avançados

### 3.1 Sistema de Gasolina
```lua
-- Sistema maneiro de gasolina
local function createFuelSystem(vehicle)
    -- Começa com tanque cheio
    setElementData(vehicle, "fuel", 100)
    
    -- Timer pra gastar gasolina
    setTimer(function()
        if getVehicleEngineState(vehicle) then
            local fuel = getElementData(vehicle, "fuel") or 100
            fuel = fuel - 0.1 -- Gasta 0.1% por seg
            
            if fuel <= 0 then
                setVehicleEngineState(vehicle, false)
                outputChatBox("Acabou a gasosa!")
            else
                setElementData(vehicle, "fuel", fuel)
            end
        end
    end, 1000, 0)
end

-- Cria sistema qnd spawna carro
addEventHandler("onVehicleSpawn", root, function()
    createFuelSystem(source)
end)
```

### 3.2 Sistema de Dano Realista
```lua
-- Dano mais realista pros carros
local function createDamageSystem(vehicle)
    -- Status dos componentes
    local components = {
        engine = 100,    -- Motor
        tires = 100,     -- Pneus
        brakes = 100     -- Freios
    }
    
    -- Qnd toma dano
    addEventHandler("onVehicleDamage", vehicle, function(loss)
        -- Calcula dano nos componentes
        components.engine = components.engine - (loss * 0.5)
        components.tires = components.tires - (loss * 0.3)
        components.brakes = components.brakes - (loss * 0.2)
        
        -- Aplica efeitos baseado no dano
        if components.engine < 50 then
            setVehicleEngineState(vehicle, false)
            outputChatBox("Motor danificado!")
        end
        
        if components.tires < 30 then
            setVehicleWheelStates(vehicle, 1, 1, 1, 1)
            outputChatBox("Pneus furados!")
        end
        
        if components.brakes < 40 then
            -- Reduz eficiência dos freios
            setVehicleHandling(vehicle, "brakeDeceleration", 3)
            outputChatBox("Freios com problema!")
        end
    end)
end

-- Aplica sistema em carros novos
addEventHandler("onVehicleSpawn", root, function()
    createDamageSystem(source)
end)
```

## 4. Dicas e Truques

### 4.1 Performance
- Use `local` nas funções pra melhor performance
- Evite criar muitos timers
- Limpe event handlers q n usa mais
- Cache valores q usa muito

### 4.2 Boas Práticas
- Sempre valide os parâmetros
- Use try/catch pra evitar erros
- Documente seu código
- Faça backup dos dados

### 4.3 Debugging
- Use `outputDebugString()` pra debug
- Verifique logs de erro
- Teste em diferentes situações
- Monitore uso de recursos

## 5. Exemplos Práticos

### 5.1 Sistema de Corrida
```lua
local RaceSystem = {
    races = {},
    
    createRace = function(self, name, checkpoints)
        local race = {
            name = name,
            checkpoints = checkpoints,
            players = {},
            started = false
        }
        
        self.races[name] = race
        return race
    end,
    
    startRace = function(self, raceName)
        local race = self.races[raceName]
        if not race then return false end
        
        race.started = true
        
        -- Avisa os players
        for player, data in pairs(race.players) do
            outputChatBox("A corrida vai começar!", player)
            
            -- Marca checkpoints
            for i, cp in ipairs(race.checkpoints) do
                createBlip(cp.x, cp.y, cp.z, 0, 2, 255, 0, 0, 255, 0, 99999, player)
            end
        end
        
        return true
    end
}
```

### 5.2 Sistema de Tunagem
```lua
local TuningSystem = {
    -- Peças disponíveis
    parts = {
        engine = {
            name = "Motor Turbo",
            price = 50000,
            boost = 1.5
        },
        brakes = {
            name = "Freios de Competição",
            price = 30000,
            boost = 1.3
        },
        tires = {
            name = "Pneus de Corrida",
            price = 20000,
            boost = 1.2
        }
    },
    
    -- Instala peça
    installPart = function(self, vehicle, partName)
        local part = self.parts[partName]
        if not part then return false end
        
        -- Aplica boost
        if partName == "engine" then
            local current = getVehicleHandling(vehicle)["maxVelocity"]
            setVehicleHandling(vehicle, "maxVelocity", 
                current * part.boost)
            
        elseif partName == "brakes" then
            local current = getVehicleHandling(vehicle)["brakeDeceleration"]
            setVehicleHandling(vehicle, "brakeDeceleration", 
                current * part.boost)
            
        elseif partName == "tires" then
            local current = getVehicleHandling(vehicle)["tractionMultiplier"]
            setVehicleHandling(vehicle, "tractionMultiplier", 
                current * part.boost)
        end
        
        outputChatBox("Nova peça instalada: " .. part.name)
        return true
    end
}
```

## 6. Solução de Problemas

### Problema: Veículo não responde aos controles
```lua
-- Verifica se tá tudo ok com o carro
function checkVehicleControls(vehicle)
    if not isElement(vehicle) then
        return "Veículo não existe!"
    end
    
    if not getVehicleEngineState(vehicle) then
        return "Motor desligado!"
    end
    
    local health = getElementHealth(vehicle)
    if health < 300 then
        return "Veículo muito danificado!"
    end
    
    return "Tudo ok!"
end
```

### Problema: Colisões não são detectadas
```lua
-- Verifica sistema de colisão
function checkCollisions(vehicle)
    -- Ativa colisões
    setElementCollisionsEnabled(vehicle, true)
    
    -- Verifica se tá funcionando
    local x, y, z = getElementPosition(vehicle)
    local hit = processLineOfSight(
        x, y, z,
        x, y, z - 10,
        true,  -- Checa construções
        true,  -- Checa veículos
        false, -- Ignora players
        true,  -- Checa objetos
        false  -- Ignora alpha
    )
    
    return hit and "Colisões OK!" or "Problema nas colisões!"
end
