# Otimização de Scripts Lua no MTA:SA

Vamos aprender a deixar seus scripts mais rápidos?

## Dicas Básicas

### 1. Variáveis Locais são Mais Rápidas
```lua
-- Ruim (variável global)
function getNome()
    nome = "João" -- Global, mais lento
    return nome
end

-- Bom (variável local)
function getNome()
    local nome = "João" -- Local, mais rápido
    return nome
end
```

### 2. Cache de Funções Usadas Muito
```lua
-- Ruim (chama getElementData toda hora)
function updatePlayer()
    if getElementData(player, "vida") < 50 then
        setElementData(player, "vida", 100)
    end
end

-- Bom (guarda em variável local)
local getElementData = getElementData
local setElementData = setElementData

function updatePlayer()
    if getElementData(player, "vida") < 50 then
        setElementData(player, "vida", 100)
    end
end
```

## Loops e Tables

### 1. Loops Otimizados
```lua
-- Ruim (recalcula #players toda vez)
local players = getElementsByType("player")
for i = 1, #players do
    -- Faz algo
end

-- Bom (guarda tamanho em variável)
local players = getElementsByType("player")
local numPlayers = #players
for i = 1, numPlayers do
    -- Faz algo
end
```

### 2. Tables Eficientes
```lua
-- Ruim (insere no meio da table)
local items = {"item1", "item2", "item4"}
table.insert(items, 3, "item3") -- Lento

-- Bom (insere no final)
local items = {"item1", "item2", "item3"}
items[#items + 1] = "item4" -- Rápido
```

## Funções e Eventos

### 1. Funções Otimizadas
```lua
-- Ruim (cria função toda vez)
function onPlayerJoin()
    local function welcome()
        outputChatBox("Bem vindo!")
    end
    welcome()
end

-- Bom (função definida fora)
local function welcome()
    outputChatBox("Bem vindo!")
end

function onPlayerJoin()
    welcome()
end
```

### 2. Eventos Eficientes
```lua
-- Ruim (muitos eventos)
for _, player in ipairs(players) do
    addEventHandler("onPlayerDamage", player, function()
        -- Código aqui
    end)
end

-- Bom (um evento só)
addEventHandler("onPlayerDamage", root, function()
    -- Código aqui
end)
```

## Memória e CPU

### 1. Gerenciamento de Memória
```lua
-- Ruim (cria strings toda hora)
function getPlayerInfo(player)
    return "Player: " .. getPlayerName(player) .. 
           " Level: " .. getElementData(player, "level") ..
           " Money: " .. getPlayerMoney(player)
end

-- Bom (usa table.concat)
function getPlayerInfo(player)
    local info = {
        "Player: ", getPlayerName(player),
        " Level: ", getElementData(player, "level"),
        " Money: ", getPlayerMoney(player)
    }
    return table.concat(info)
end
```

### 2. Processamento Pesado
```lua
-- Ruim (roda toda hora)
addEventHandler("onClientRender", root, function()
    for _, player in ipairs(getElementsByType("player")) do
        -- Cálculos pesados aqui
    end
end)

-- Bom (usa timer)
setTimer(function()
    for _, player in ipairs(getElementsByType("player")) do
        -- Cálculos pesados aqui
    end
end, 1000, 0) -- Roda a cada 1s
```

## Dicas Avançadas

### 1. Metatables Otimizadas
```lua
-- Ruim (metatable pra td)
local Player = {}
setmetatable({}, {__index = Player})

-- Bom (só qnd precisa)
local Player = {}
local meta = {__index = Player}

function Player.new()
    return setmetatable({}, meta)
end
```

### 2. Garbage Collection
```lua
-- Ruim (mta GC manual)
function bigFunction()
    local bigTable = {}
    -- Código aqui
    collectgarbage() -- N faça isso
end

-- Bom (deixa o GC trabalhar)
function bigFunction()
    local bigTable = {}
    -- Código aqui
    bigTable = nil -- Só marca pra GC
end
```

## Dicas Práticas

### 1. Oq Evitar
1. **Loops dentro de Loops**
   - Pesado pro server
   - Difícil de manter
   - Tem jeito melhor

2. **Funções Anônimas em Eventos**
   - Gasta memória
   - Difícil debugar
   - Melhor definir antes

3. **Strings Concatenadas**
   - Cria mta string nova
   - Usa mais memória
   - Usa table.concat

### 2. Oq Fazer
1. **Cache de Dados**
   - Guarda oq usa mto
   - Atualiza só qnd muda
   - Economiza processamento

2. **Timers Espertos**
   - N usa timer curto
   - Agrupa processamento
   - Evita sobrecarga

3. **Código Limpo**
   - Mais fácil otimizar
   - Mais fácil achar prob
   - Todo mundo entende
