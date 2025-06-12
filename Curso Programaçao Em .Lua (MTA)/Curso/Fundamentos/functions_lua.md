# Funções em Lua

Vamos aprender sobre funções em Lua? São blocos de código que você pode reusar.

## O que são Funções?

São blocos de código que você pode reusar. Tipo receitas que você pode chamar várias vezes!

## Tipos de Funções

### 1. Funções Básicas
```lua
-- Função simples
function dizOi()
    print("Oi!")
end

-- Com parâmetros
function soma(a, b)
    return a + b
end

-- Uso
dizOi()  -- Oi!
print(soma(2, 3))  -- 5
```

### 2. Funções Anônimas
```lua
-- Guardada em variável
local multiplica = function(a, b)
    return a * b
end

-- Passada como parâmetro
setTimer(function()
    print("5 segundos!")
end, 5000, 1)
```

### 3. Funções com Retorno Múltiplo
```lua
-- Retorna vários valores
function divide(a, b)
    return a / b, a % b
end

-- Pega os valores
local quociente, resto = divide(10, 3)
print(quociente, resto)  -- 3.333..., 1
```

## Parâmetros

### 1. Parâmetros Opcionais
```lua
-- Com valor padrão
function cumprimentar(nome, msg)
    msg = msg or "Oi"  -- valor padrão
    print(msg .. ", " .. nome .. "!")
end

-- Uso
cumprimentar("João")  -- Oi, João!
cumprimentar("João", "Olá")  -- Olá, João!
```

### 2. Número Variável
```lua
-- Pega todos os args
function soma(...)
    local total = 0
    for _, n in ipairs({...}) do
        total = total + n
    end
    return total
end

-- Uso
print(soma(1, 2, 3))  -- 6
print(soma(1, 2, 3, 4, 5))  -- 15
```

## Escopo

### 1. Local vs Global
```lua
-- Global (não recomendado)
function globalFunc()
    print("Global")
end

-- Local (melhor)
local function localFunc()
    print("Local")
end
```

### 2. Closures
```lua
-- Função que retorna função
function contador()
    local count = 0
    return function()
        count = count + 1
        return count
    end
end

-- Uso
local cont = contador()
print(cont())  -- 1
print(cont())  -- 2
print(cont())  -- 3
```

## Exemplos Práticos

### 1. Sistema de Inventário
```lua
-- Funções do inventário
local Inventario = {
    addItem = function(player, item)
        -- Checa espaço
        local items = getElementData(player, "items") or {}
        if #items >= 20 then
            return false, "Inventário cheio"
        end
        
        -- Adiciona
        table.insert(items, item)
        setElementData(player, "items", items)
        return true
    end,
    
    removeItem = function(player, index)
        -- Pega items
        local items = getElementData(player, "items") or {}
        if not items[index] then
            return false, "Item não existe"
        end
        
        -- Remove
        table.remove(items, index)
        setElementData(player, "items", items)
        return true
    end,
    
    getItems = function(player)
        return getElementData(player, "items") or {}
    end
}

-- Uso
Inventario.addItem(player, {nome = "Espada", dano = 10})
local items = Inventario.getItems(player)
```

### 2. Sistema de Veículos
```lua
-- Funções de veículos
local Veiculos = {
    criar = function(modelo, x, y, z)
        -- Cria
        local veiculo = createVehicle(modelo, x, y, z)
        if not veiculo then
            return false, "Falha ao criar"
        end
        
        -- Configura
        setElementHealth(veiculo, 1000)
        setVehicleDamageProof(veiculo, false)
        return veiculo
    end,
    
    destruir = function(veiculo)
        if isElement(veiculo) then
            destroyElement(veiculo)
            return true
        end
        return false, "Veículo não existe"
    end,
    
    reparar = function(veiculo)
        if not isElement(veiculo) then
            return false, "Veículo não existe"
        end
        
        fixVehicle(veiculo)
        setElementHealth(veiculo, 1000)
        return true
    end
}

-- Uso
local carro = Veiculos.criar(411, 0, 0, 3)
Veiculos.reparar(carro)
```

### 3. Sistema de Combate
```lua
-- Funções de combate
local Combate = {
    dano = function(player, atacante, dano)
        -- Valida
        if not isElement(player) or not isElement(atacante) then
            return false, "Player inválido"
        end
        
        -- Aplica dano
        local vida = getElementHealth(player)
        setElementHealth(player, vida - dano)
        
        -- Checa morte
        if vida - dano <= 0 then
            Combate.morte(player, atacante)
        end
        return true
    end,
    
    morte = function(player, killer)
        -- Mata
        killPed(player)
        
        -- Respawn depois
        setTimer(function()
            Combate.respawn(player)
        end, 5000, 1)
    end,
    
    respawn = function(player)
        -- Respawn
        spawnPlayer(player, 0, 0, 3)
        setElementHealth(player, 100)
        return true
    end
}

-- Uso
addEventHandler("onPlayerDamage", root,
    function(atacante, arma, corpo, dano)
        Combate.dano(source, atacante, dano)
    end
)
```

## Dicas Importantes

### 1. Organização
```lua
-- Agrupa funções relacionadas
local Utils = {
    print = function(...)
        outputDebugString(table.concat({...}, " "))
    end,
    
    log = function(tipo, msg)
        print(string.format("[%s] %s", tipo, msg))
    end,
    
    erro = function(msg)
        log("ERRO", msg)
    end
}
```

### 2. Performance
```lua
-- Guarda funções usadas muito
local sin = math.sin
local cos = math.cos

-- Melhor que chamar math.sin toda hora
function calcAngulo(x, y)
    return sin(x) * cos(y)
end
```

### 3. Documentação
```lua
--- Soma dois números
-- @param a Primeiro número
-- @param b Segundo número
-- @return Soma dos números
function soma(a, b)
    return a + b
end
```

## Conclusão

Funções são importantes porque:
- Organizam código
- Evitam repetição
- Facilitam manutenção
- Melhoram legibilidade

Lembra:
- Use nomes claros
- Faça uma coisa só
- Documente bem
- Código limpo é código feliz!
