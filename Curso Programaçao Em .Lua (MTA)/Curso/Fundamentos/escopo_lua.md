# Escopo em Lua

E aí dev! Vamo entender como funciona o escopo das variáveis em Lua?

## O que é Escopo?

Escopo é onde suas variáveis "vivem" no código:
- Escopo local: só existe num pedaço do código
- Escopo global: existe em todo lugar

## Variáveis Locais

### Básico
```lua
local nome = "João" -- Só existe nesse arquivo

function dizerOi()
    local msg = "Oi " .. nome -- msg só existe na função
    outputChatBox(msg)
end
```

### Em Blocos
```lua
if true then
    local x = 10 -- Só existe no if
end
-- x não existe aqui!

for i = 1, 3 do
    local num = i -- num só existe no loop
end
-- num não existe aqui!
```

## Variáveis Globais

### Básico
```lua
vida = 100 -- Global! Cuidado!

function curar()
    vida = vida + 10 -- Usa a global
end
```

### Por que Evitar
```lua
-- Ruim: Global
contador = 0

-- Melhor: Local
local contador = 0
```

## Escopo em Funções

### Parâmetros
```lua
local function darItem(player, item)
    -- player e item são locais da função
    if not player then return end
    
    local quantidade = 1
    outputChatBox("Ganhou " .. quantidade .. "x " .. item)
end
```

### Closures
```lua
function criarContador()
    local count = 0
    
    return function()
        count = count + 1
        return count
    end
end

local contador = criarContador()
print(contador()) -- 1
print(contador()) -- 2
```

## Exemplos Práticos

### Sistema de Inventário
```lua
-- Módulo de inventário
local Inventario = {
    slots = 20,
    items = {}
}

function Inventario.adicionar(item)
    if #Inventario.items >= Inventario.slots then
        return false, "Inventário cheio"
    end
    
    table.insert(Inventario.items, item)
    return true
end

function Inventario.remover(item)
    for i, itemSlot in ipairs(Inventario.items) do
        if itemSlot == item then
            table.remove(Inventario.items, i)
            return true
        end
    end
    return false, "Item não encontrado"
end

-- Usar
local sucesso = Inventario.adicionar("espada")
```

### Sistema de Pontos
```lua
-- Escopo do módulo
local Pontos = {
    jogadores = {}
}

-- Funções locais helpers
local function validarPlayer(player)
    return isElement(player) and getElementType(player) == "player"
end

local function getPontosPlayer(player)
    return Pontos.jogadores[player] or 0
end

-- Funções públicas
function Pontos.adicionar(player, quantidade)
    if not validarPlayer(player) then
        return false, "Player inválido"
    end
    
    quantidade = quantidade or 1
    Pontos.jogadores[player] = getPontosPlayer(player) + quantidade
    
    outputChatBox("Ganhou " .. quantidade .. " pontos!", player)
    return true
end

function Pontos.remover(player, quantidade)
    if not validarPlayer(player) then
        return false, "Player inválido"
    end
    
    local pontosAtuais = getPontosPlayer(player)
    quantidade = quantidade or 1
    
    if pontosAtuais < quantidade then
        return false, "Pontos insuficientes"
    end
    
    Pontos.jogadores[player] = pontosAtuais - quantidade
    outputChatBox("Perdeu " .. quantidade .. " pontos!", player)
    return true
end
```

### Sistema de Cache
```lua
-- Cache module
local Cache = {
    dados = {},
    tempo = {}
}

-- Funções locais
local function limparCache()
    local agora = getTickCount()
    
    for chave, tempo in pairs(Cache.tempo) do
        if agora > tempo then
            Cache.dados[chave] = nil
            Cache.tempo[chave] = nil
        end
    end
end

-- Funções públicas
function Cache.set(chave, valor, duracao)
    Cache.dados[chave] = valor
    Cache.tempo[chave] = getTickCount() + (duracao or 60000)
end

function Cache.get(chave)
    limparCache() -- Limpa cache vencido
    return Cache.dados[chave]
end
```

## Dicas Importantes

### 1. Use Local Sempre que Puder
```lua
-- Ruim
contador = 0

-- Melhor
local contador = 0
```

### 2. Module Pattern
```lua
-- arquivo: minhaLib.lua
local MinhaLib = {}

function MinhaLib.funcao1()
    -- código
end

function MinhaLib.funcao2()
    -- código
end

return MinhaLib

-- usar
local minhaLib = require("minhaLib")
minhaLib.funcao1()
```

### 3. Evite Globais
```lua
-- Ruim
CONFIGURACAO = {
    maxPlayers = 32,
    mapName = "DM"
}

-- Melhor
local CONFIGURACAO = {
    maxPlayers = 32,
    mapName = "DM"
}
```

## Conclusão

Escopo é importante porque:
- Evita conflitos
- Organiza código
- Melhora performance

Lembra:
- Use local por padrão
- Evite globais
- Organize em módulos
- Código limpo é código feliz
