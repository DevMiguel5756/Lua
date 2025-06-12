# Metatabelas em Lua

## Conceitos Básicos

### 1. O que são Metatabelas
```lua
-- Tabela normal
local tabela = {x = 10, y = 20}

-- Metatabela
local meta = {
    __index = function(t, k)
        return 0  -- valor padrão
    end
}

-- Aplicar metatabela
setmetatable(tabela, meta)
```

### 2. Metamétodos Básicos
```lua
local meta = {
    -- Acesso a índices inexistentes
    __index = function(t, k)
        return 0
    end,
    
    -- Definição de índices
    __newindex = function(t, k, v)
        rawset(t, k, v * 2)  -- dobra o valor
    end,
    
    -- Conversão para string
    __tostring = function(t)
        return "X: " .. t.x .. ", Y: " .. t.y
    end
}
```

### 3. Operadores
```lua
local meta = {
    -- Soma
    __add = function(a, b)
        return {x = a.x + b.x, y = a.y + b.y}
    end,
    
    -- Subtração
    __sub = function(a, b)
        return {x = a.x - b.x, y = a.y - b.y}
    end,
    
    -- Multiplicação
    __mul = function(a, b)
        return {x = a.x * b, y = a.y * b}
    end
}
```

## Usos Comuns

### 1. Valores Padrão
```lua
local config = {
    maxPlayers = 32,
    gamemode = "deathmatch"
}

local meta = {
    __index = {
        maxPlayers = 16,
        gamemode = "freeroam",
        weather = 0,
        time = 12
    }
}

setmetatable(config, meta)
```

### 2. Proxy
```lua
local proxy = {}
local real = {}

local meta = {
    __index = function(t, k)
        print("Acessando: " .. k)
        return real[k]
    end,
    
    __newindex = function(t, k, v)
        print("Definindo: " .. k .. " = " .. tostring(v))
        real[k] = v
    end
}

setmetatable(proxy, meta)
```

### 3. Validação
```lua
local player = {
    vida = 100,
    colete = 100
}

local meta = {
    __newindex = function(t, k, v)
        if k == "vida" or k == "colete" then
            v = math.max(0, math.min(100, v))
        end
        rawset(t, k, v)
    end
}

setmetatable(player, meta)
```

## Programação Orientada a Objetos

### 1. Classes
```lua
-- Definição da classe
local Veiculo = {}
Veiculo.__index = Veiculo

function Veiculo.new(modelo)
    local self = setmetatable({}, Veiculo)
    self.modelo = modelo
    self.vida = 1000
    self.velocidade = 0
    return self
end

function Veiculo:acelerar(valor)
    self.velocidade = self.velocidade + valor
end

function Veiculo:frear(valor)
    self.velocidade = math.max(0, self.velocidade - valor)
end

-- Uso
local carro = Veiculo.new(411)
carro:acelerar(10)
```

### 2. Herança
```lua
-- Classe base
local Veiculo = {}
Veiculo.__index = Veiculo

function Veiculo.new(modelo)
    local self = setmetatable({}, Veiculo)
    self.modelo = modelo
    return self
end

-- Classe derivada
local Carro = setmetatable({}, {__index = Veiculo})
Carro.__index = Carro

function Carro.new(modelo, portas)
    local self = Veiculo.new(modelo)
    setmetatable(self, Carro)
    self.portas = portas
    return self
end

function Carro:abrirPortas()
    print("Abrindo " .. self.portas .. " portas")
end
```

### 3. Polimorfismo
```lua
-- Classe base
local Animal = {}
Animal.__index = Animal

function Animal.new(nome)
    local self = setmetatable({}, Animal)
    self.nome = nome
    return self
end

function Animal:som()
    return "..."
end

-- Classes derivadas
local Cachorro = setmetatable({}, {__index = Animal})
Cachorro.__index = Cachorro

function Cachorro.new(nome)
    local self = Animal.new(nome)
    setmetatable(self, Cachorro)
    return self
end

function Cachorro:som()
    return "Au au!"
end

local Gato = setmetatable({}, {__index = Animal})
Gato.__index = Gato

function Gato.new(nome)
    local self = Animal.new(nome)
    setmetatable(self, Gato)
    return self
end

function Gato:som()
    return "Miau!"
end
```

## Exemplos Práticos

### 1. Sistema de Inventário
```lua
local Inventario = {}
Inventario.__index = Inventario

function Inventario.new(tamanhoMax)
    local self = setmetatable({}, Inventario)
    self.items = {}
    self.tamanhoMax = tamanhoMax
    return self
end

function Inventario:adicionar(item)
    if #self.items >= self.tamanhoMax then
        return false, "Inventário cheio"
    end
    table.insert(self.items, item)
    return true
end

function Inventario:remover(index)
    if not self.items[index] then
        return false, "Item não encontrado"
    end
    return table.remove(self.items, index)
end

-- Metatabela para validação
local meta = {
    __newindex = function(t, k, v)
        if k == "tamanhoMax" then
            v = math.max(1, v)
        end
        rawset(t, k, v)
    end
}

setmetatable(Inventario, meta)
```

### 2. Sistema de Eventos
```lua
local EventManager = {}
EventManager.__index = EventManager

function EventManager.new()
    local self = setmetatable({}, EventManager)
    self.handlers = {}
    return self
end

function EventManager:registrar(evento, callback)
    if not self.handlers[evento] then
        self.handlers[evento] = {}
    end
    table.insert(self.handlers[evento], callback)
end

function EventManager:disparar(evento, ...)
    if not self.handlers[evento] then return end
    
    for _, handler in ipairs(self.handlers[evento]) do
        handler(...)
    end
end

-- Metatabela para logging
local meta = {
    __call = function(self, evento, ...)
        print("Disparando evento: " .. evento)
        return self:disparar(evento, ...)
    end
}

setmetatable(EventManager, meta)
```

### 3. Sistema de Configuração
```lua
local Config = {}

-- Valores padrão
local defaults = {
    maxPlayers = 32,
    gamemode = "deathmatch",
    weather = 0,
    time = 12,
    spawnPoints = {
        {x = 0, y = 0, z = 3}
    }
}

-- Validações
local validations = {
    maxPlayers = function(v)
        return type(v) == "number" and v >= 1 and v <= 100
    end,
    
    weather = function(v)
        return type(v) == "number" and v >= 0 and v <= 20
    end,
    
    time = function(v)
        return type(v) == "number" and v >= 0 and v <= 23
    end
}

-- Metatabela
local meta = {
    -- Valores padrão
    __index = defaults,
    
    -- Validação
    __newindex = function(t, k, v)
        if validations[k] and not validations[k](v) then
            error("Valor inválido para " .. k)
        end
        rawset(t, k, v)
    end,
    
    -- Serialização
    __tostring = function(t)
        local str = "Configuração:\n"
        for k, v in pairs(t) do
            if type(v) ~= "table" then
                str = str .. k .. " = " .. tostring(v) .. "\n"
            end
        end
        return str
    end
}

setmetatable(Config, meta)
```

## Boas Práticas

### 1. Encapsulamento
```lua
-- Usar metatabelas para proteger dados
local function criarJogador()
    local dados = {
        vida = 100,
        colete = 100
    }
    
    local meta = {
        __index = dados,
        __newindex = function()
            error("Não pode modificar diretamente")
        end
    }
    
    return setmetatable({}, meta)
end
```

### 2. Performance
```lua
-- Cache de metamétodos frequentes
local meta = {
    __index = function(t, k)
        -- Computação pesada
        local v = calcularValor(k)
        -- Cache do resultado
        rawset(t, k, v)
        return v
    end
}
```

### 3. Clareza
```lua
-- Documentar comportamento
local meta = {
    __index = function(t, k)
        -- Retorna 0 para índices inexistentes
        return 0
    end,
    
    __newindex = function(t, k, v)
        -- Valida e normaliza valores
        if type(v) ~= "number" then
            error("Apenas números permitidos")
        end
        rawset(t, k, math.floor(v))
    end
}
```

## Conclusão

Metatabelas são poderosas para:
- Programação OOP
- Validação de dados
- Comportamento customizado
- Encapsulamento

Lembre-se de:
- Usar com moderação
- Documentar bem
- Manter simples
- Código limpo é código feliz
