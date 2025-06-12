# Funções Maneiras pro Seu Server

E aí, dev! Vamos aprender umas funções massa pro seu server? Tem muita coisa legal aqui!

## 1. Funções pra Veículos

### 1.1 Sistema de Tuning
```lua
-- Função pra tunar carro
function tunarCarro(veiculo)
    -- Adiciona upgrades
    addVehicleUpgrade(veiculo, 1010) -- Nitro
    addVehicleUpgrade(veiculo, 1087) -- Hidráulica
    
    -- Melhora handling
    local handling = getVehicleHandling(veiculo)
    handling.maxVelocity = handling.maxVelocity * 1.2
    handling.engineAcceleration = handling.engineAcceleration * 1.3
    setVehicleHandling(veiculo, handling)
    
    return true
end
```

### 1.2 Sistema de Dano Realista
```lua
-- Função pra dano realista
function damageSystem(veiculo, loss)
    -- Pega status atual
    local health = getElementHealth(veiculo)
    
    -- Aplica efeitos baseado no dano
    if health < 400 then
        setVehicleEngineState(veiculo, false)
        outputChatBox("Motor danificado!")
    end
    
    if health < 600 then
        setVehicleWheelStates(veiculo, 1, 1, 1, 1)
        outputChatBox("Pneus furados!")
    end
end

-- Adiciona handler
addEventHandler("onVehicleDamage", root, damageSystem)
```

## 2. Funções pra Players

### 2.1 Sistema de Level
```lua
-- Função pra dar XP
function darXP(player, amount)
    -- Pega XP atual
    local xp = getElementData(player, "xp") or 0
    local level = getElementData(player, "level") or 1
    
    -- Adiciona XP
    xp = xp + amount
    
    -- Checa level up
    local xpProximoLevel = level * 1000
    if xp >= xpProximoLevel then
        level = level + 1
        xp = xp - xpProximoLevel
        
        -- Avisa player
        outputChatBox("Level up! Agora vc é level " .. level, 
            player)
    end
    
    -- Salva dados
    setElementData(player, "xp", xp)
    setElementData(player, "level", level)
end
```

### 2.2 Sistema de Skills
```lua
-- Skills disponíveis
local SKILLS = {
    strength = {
        name = "Força",
        max = 100,
        effect = function(player, level)
            setPedStat(player, 24, level)
        end
    },
    stamina = {
        name = "Stamina", 
        max = 100,
        effect = function(player, level)
            setPedStat(player, 22, level)
        end
    }
}

-- Função pra upar skill
function uparSkill(player, skill, amount)
    if not SKILLS[skill] then return false end
    
    -- Pega level atual
    local level = getElementData(player, "skill." .. skill) or 0
    
    -- Checa máximo
    if level >= SKILLS[skill].max then
        return false
    end
    
    -- Adiciona pontos
    level = level + amount
    if level > SKILLS[skill].max then
        level = SKILLS[skill].max
    end
    
    -- Aplica efeito
    SKILLS[skill].effect(player, level)
    
    -- Salva
    setElementData(player, "skill." .. skill, level)
    return true
end
```

## 3. Funções de Craft

### 3.1 Sistema de Receitas
```lua
-- Receitas disponíveis
local RECIPES = {
    potion = {
        name = "Poção de Vida",
        ingredients = {
            ["erva"] = 2,
            ["cogumelo"] = 1
        },
        result = "potion",
        amount = 1
    }
}

-- Função pra craftar item
function craftItem(player, recipe)
    if not RECIPES[recipe] then return false end
    
    -- Checa ingredientes
    for item, amount in pairs(RECIPES[recipe].ingredients) do
        local playerAmount = getElementData(player, "inv." .. item) or 0
        if playerAmount < amount then
            return false, "Faltam ingredientes!"
        end
    end
    
    -- Remove ingredientes
    for item, amount in pairs(RECIPES[recipe].ingredients) do
        local playerAmount = getElementData(player, "inv." .. item)
        setElementData(player, "inv." .. item, playerAmount - amount)
    end
    
    -- Dá o item craftado
    local resultItem = RECIPES[recipe].result
    local resultAmount = RECIPES[recipe].amount
    local currentAmount = getElementData(player, "inv." .. resultItem) or 0
    setElementData(player, "inv." .. resultItem, currentAmount + resultAmount)
    
    return true
end
```

## 4. Sistema de Menu

### 4.1 Menu Dinâmico
```lua
-- Menu base
Menu = {
    -- Cria novo menu
    new = function(self, title)
        local menu = {
            title = title,
            items = {},
            selected = 1,
            visible = false
        }
        
        setmetatable(menu, self)
        self.__index = self
        return menu
    end,
    
    -- Adiciona item
    addItem = function(self, text, callback)
        table.insert(self.items, {
            text = text,
            callback = callback
        })
    end,
    
    -- Mostra menu
    show = function(self)
        if self.visible then return end
        self.visible = true
        self:draw()
        
        bindKey("arrow_u", "down", self.up)
        bindKey("arrow_d", "down", self.down)
        bindKey("enter", "down", self.select)
    end
}
```

## 5. Sistema de Log

### 5.1 Logger Maneiro
```lua
-- Sistema de log
Logger = {
    -- Níveis de log
    LEVELS = {
        DEBUG = 1,
        INFO = 2,
        WARN = 3,
        ERROR = 4
    },
    
    -- Config padrão
    config = {
        level = "INFO",
        file = "server.log",
        console = true
    },
    
    -- Loga msg
    log = function(self, level, msg)
        if self.LEVELS[level] < self.LEVELS[self.config.level] then
            return
        end
        
        local time = os.date("%H:%M:%S")
        local logMsg = string.format("[%s] [%s] %s", 
            time, level, msg)
        
        -- Salva no arquivo
        if self.config.file then
            local f = fileOpen(self.config.file, true)
            if f then
                fileSetPos(f, fileGetSize(f))
                fileWrite(f, logMsg .. "\n")
                fileClose(f)
            end
        end
        
        -- Mostra no console
        if self.config.console then
            outputDebugString(logMsg)
        end
    end
}
