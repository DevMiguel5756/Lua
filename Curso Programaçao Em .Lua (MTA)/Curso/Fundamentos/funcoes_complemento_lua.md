# Funções Complementares em Lua

E aí galera! Vamo continuar aprendendo sobre funções em Lua? Aqui tem mais algumas paradas maneiras q vc pode fazer!

## Funções Matemáticas

### 1. Arredondamento
```lua
local num = 3.7
print(math.floor(num))  -- 3 (arredonda pra baixo)
print(math.ceil(num))   -- 4 (arredonda pra cima)
print(math.round(num))  -- 4 (arredonda pro mais próximo)
```

### 2. Aleatório
```lua
-- Número aleatório entre 1 e 100
local sorteio = math.random(1, 100)

-- Posição aleatória
local x = math.random(-100, 100)
local y = math.random(-100, 100)
local z = math.random(0, 50)
```

## Funções de String

### 1. Manipulação
```lua
local texto = "  Oi Mundo!  "
print(string.upper(texto))     -- "  OI MUNDO!  "
print(string.lower(texto))     -- "  oi mundo!  "
print(string.trim(texto))      -- "Oi Mundo!"
```

### 2. Busca e Replace
```lua
local msg = "Oi mano, blz mano?"
print(string.find(msg, "mano"))      -- acha primeira ocorrência
print(string.gsub(msg, "mano", "cara")) -- troca todas
```

## Funções de Tabela

### 1. Manipulação
```lua
local lista = {"a", "b", "c"}
table.insert(lista, "d")      -- adiciona no fim
table.remove(lista, 2)        -- remove o "b"
table.sort(lista)             -- ordena
```

### 2. Conversão
```lua
local nomes = {"João", "Maria", "Pedro"}
print(table.concat(nomes, ", "))  -- "João, Maria, Pedro"
```

## Funções de Tempo

### 1. Timers
```lua
-- Timer único
setTimer(function()
    outputChatBox("5 segundos se passaram!")
end, 5000, 1)

-- Timer repetitivo
local timer = setTimer(function()
    outputChatBox("Tick!")
end, 1000, 0)  -- 0 = infinito
```

### 2. Medição
```lua
local inicio = getTickCount()
-- faz algo
local fim = getTickCount()
local tempo = fim - inicio
```

## Funções de Debug

### 1. Print Avançado
```lua
local function printTabela(t)
    for k, v in pairs(t) do
        outputDebugString(k .. " = " .. tostring(v))
    end
end

-- Uso
local info = {nome = "João", idade = 25}
printTabela(info)
```

### 2. Trace
```lua
local function trace(msg)
    local info = debug.getinfo(2, "Sl")
    outputDebugString(string.format(
        "[%s:%d] %s",
        info.short_src,
        info.currentline,
        msg
    ))
end
```

## Funções de Arquivo

### 1. Leitura
```lua
function lerArquivo(nome)
    local arquivo = fileOpen(nome)
    if not arquivo then return nil end
    
    local conteudo = fileRead(arquivo, fileGetSize(arquivo))
    fileClose(arquivo)
    
    return conteudo
end
```

### 2. Escrita
```lua
function salvarArquivo(nome, dados)
    local arquivo = fileCreate(nome)
    if not arquivo then return false end
    
    fileWrite(arquivo, dados)
    fileClose(arquivo)
    
    return true
end
```

## Funções de Elemento

### 1. Manipulação
```lua
function moverElemento(elemento, x, y, z, tempo)
    local ex, ey, ez = getElementPosition(elemento)
    
    local dx = (x - ex) / tempo
    local dy = (y - ey) / tempo
    local dz = (z - ez) / tempo
    
    return setTimer(function()
        setElementPosition(elemento, x, y, z)
    end, tempo, 1)
end
```

### 2. Estado
```lua
function salvarEstado(elemento)
    local x, y, z = getElementPosition(elemento)
    local rx, ry, rz = getElementRotation(elemento)
    
    return {
        pos = {x = x, y = y, z = z},
        rot = {x = rx, y = ry, z = rz},
        saude = getElementHealth(elemento),
        modelo = getElementModel(elemento)
    }
end

function carregarEstado(elemento, estado)
    setElementPosition(elemento, 
        estado.pos.x, 
        estado.pos.y, 
        estado.pos.z)
    
    setElementRotation(elemento,
        estado.rot.x,
        estado.rot.y,
        estado.rot.z)
    
    setElementHealth(elemento, estado.saude)
    setElementModel(elemento, estado.modelo)
end
```

## Exemplo Completo

Sistema de checkpoint com funções:

```lua
-- Config
local checkpoints = {
    {x = 100, y = 100, z = 10},
    {x = 200, y = 200, z = 10},
    {x = 300, y = 100, z = 10}
}

-- Funções auxiliares
local function criarCheckpoint(pos, numero)
    local marker = createMarker(pos.x, pos.y, pos.z - 1,
        "cylinder", 2, 255, 0, 0, 150)
        
    local blip = createBlipAttachedTo(marker, 0)
    
    setElementData(marker, "checkpoint", {
        numero = numero,
        proximo = checkpoints[numero + 1]
    })
    
    return marker
end

local function destruirCheckpoint(marker)
    local blip = getBlipAttachedTo(marker)
    if blip then destroyElement(blip) end
    destroyElement(marker)
end

-- Funções principais
function iniciarCorrida(player)
    -- Limpa checkpoints antigos
    for _, marker in ipairs(getElementsByType("marker")) do
        destruirCheckpoint(marker)
    end
    
    -- Cria novos
    for i, pos in ipairs(checkpoints) do
        criarCheckpoint(pos, i)
    end
    
    -- Setup player
    setElementData(player, "checkpoint_atual", 1)
    spawnPlayer(player, 
        checkpoints[1].x,
        checkpoints[1].y,
        checkpoints[1].z)
end

function checaCheckpoint(player, marker)
    local checkpoint = getElementData(marker, "checkpoint")
    local atual = getElementData(player, "checkpoint_atual")
    
    if checkpoint.numero == atual then
        -- Passou!
        if checkpoint.proximo then
            -- Próximo checkpoint
            setElementData(player, "checkpoint_atual",
                atual + 1)
            outputChatBox("Checkpoint " .. atual .. "!", player)
        else
            -- Terminou!
            outputChatBox("Corrida completa!", player)
            iniciarCorrida(player)
        end
    end
end

-- Eventos
addEventHandler("onMarkerHit", root, function(player)
    if getElementType(player) == "player" then
        checaCheckpoint(player, source)
    end
end)

addCommandHandler("corrida", function(player)
    iniciarCorrida(player)
end)
```

É isso aí galera! Essas são mais algumas funções maneiras q vc pode usar nos seus scripts. Qualquer dúvida só chamar! 😎
