# Loops em Lua

Vamos aprender sobre loops em Lua? São super úteis pra fazer coisas repetitivas!

## O que são Loops?

São estruturas que repetem código várias vezes. Tipo quando você precisa fazer a mesma coisa várias vezes!

## Tipos de Loops

### 1. While
```lua
-- Repete enquanto condição é true
local count = 0
while count < 5 do
    print(count)
    count = count + 1
end

-- Com break
local i = 0
while true do
    if i >= 5 then
        break
    end
    print(i)
    i = i + 1
end
```

### 2. Repeat
```lua
-- Repete até condição ser true
local count = 0
repeat
    print(count)
    count = count + 1
until count >= 5

-- Com break
local i = 0
repeat
    if i >= 5 then
        break
    end
    print(i)
    i = i + 1
until false
```

### 3. For Numérico
```lua
-- De 1 até 5
for i = 1, 5 do
    print(i)
end

-- Com passo 2
for i = 0, 10, 2 do
    print(i)  -- 0, 2, 4, 6, 8, 10
end

-- Decrescente
for i = 5, 1, -1 do
    print(i)  -- 5, 4, 3, 2, 1
end
```

### 4. For Genérico
```lua
-- Em tabela
local frutas = {"maçã", "banana", "laranja"}
for i, fruta in ipairs(frutas) do
    print(i, fruta)
end

-- Em pares
local pessoa = {nome = "João", idade = 25}
for chave, valor in pairs(pessoa) do
    print(chave, valor)
end
```

## Controle de Loop

### 1. Break
```lua
-- Para o loop
for i = 1, 10 do
    if i == 5 then
        break  -- Para no 5
    end
    print(i)
end
```

### 2. Continue (Simulado)
```lua
-- Pula iteração
for i = 1, 5 do
    if i == 3 then
        goto continue  -- Pula o 3
    end
    print(i)
    ::continue::
end
```

## Exemplos Práticos

### 1. Sistema de Inventário
```lua
-- Loop em slots
function procurarItem(player, item)
    for slot = 1, 20 do
        local itemSlot = getElementData(player, "slot." .. slot)
        if itemSlot == item then
            return slot
        end
    end
    return false
end

-- Loop em items
function contarItems(player)
    local total = 0
    for slot = 1, 20 do
        if getElementData(player, "slot." .. slot) then
            total = total + 1
        end
    end
    return total
end
```

### 2. Sistema de Veículos
```lua
-- Loop em veículos
function destruirVeiculosVazios()
    local veiculos = getElementsByType("vehicle")
    for _, veiculo in ipairs(veiculos) do
        if not getVehicleController(veiculo) then
            destroyElement(veiculo)
        end
    end
end

-- Loop com timer
function checarVeiculos()
    local count = 0
    setTimer(function()
        local veiculos = getElementsByType("vehicle")
        for _, veiculo in ipairs(veiculos) do
            local vida = getElementHealth(veiculo)
            if vida < 300 then
                setVehicleEngineState(veiculo, false)
            end
        end
        
        count = count + 1
        if count >= 10 then
            return "stop"
        end
    end, 1000, 0)
end
```

### 3. Sistema de Missões
```lua
-- Loop em objetivos
function checarObjetivos(missao)
    local completos = 0
    for _, objetivo in ipairs(missao.objetivos) do
        if objetivo.completo then
            completos = completos + 1
        end
    end
    return completos == #missao.objetivos
end

-- Loop com delay
function spawnObjetivos(missao)
    local i = 0
    local function spawn()
        i = i + 1
        if i <= #missao.objetivos then
            local obj = missao.objetivos[i]
            createPickup(obj.x, obj.y, obj.z, 3, obj.id)
            setTimer(spawn, 1000, 1)
        end
    end
    spawn()
end
```

## Dicas Importantes

### 1. Performance
```lua
-- Cache de funções
local ipairs = ipairs
local pairs = pairs
local print = print

-- Melhor performance
local t = {"a", "b", "c"}
for i = 1, #t do  -- Mais rápido que ipairs
    print(t[i])
end
```

### 2. Memória
```lua
-- Libera memória
local function processar()
    local dados = {}
    for i = 1, 1000000 do
        dados[i] = i
    end
    -- Usa dados
    dados = nil  -- Libera memória
end
```

### 3. Segurança
```lua
-- Previne loops infinitos
local MAX_ITER = 1000
local count = 0

while true do
    count = count + 1
    if count > MAX_ITER then
        error("Loop infinito!")
        break
    end
    -- código aqui
end
```

## Conclusão

Loops são importantes porque:
- Automatizam tarefas
- Processam dados
- Economizam código
- Facilitam manutenção

Lembra:
- Cuide da performance
- Evite loops infinitos
- Use o tipo certo
- Código limpo é código feliz!
