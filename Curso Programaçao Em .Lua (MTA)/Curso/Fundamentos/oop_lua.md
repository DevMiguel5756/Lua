# Programação Orientada a Objetos em Lua

E aí dev! Vamo aprender sobre OOP em Lua? É um jeito super legal de organizar seu código!

## O que é OOP?

É um jeito de programar onde você organiza o código em "objetos" que têm dados e funções juntos.

## Classes e Objetos

### 1. Classe Básica
```lua
-- Classe Player
local Player = {
    vida = 100,
    nivel = 1
}

function Player:new(nome)
    local obj = {}
    setmetatable(obj, {__index = self})
    obj.nome = nome
    return obj
end

function Player:dano(valor)
    self.vida = self.vida - valor
    if self.vida <= 0 then
        self:morrer()
    end
end

function Player:morrer()
    print(self.nome .. " morreu!")
end

-- Uso
local player1 = Player:new("João")
player1:dano(50)
```

### 2. Herança
```lua
-- Classe base
local Veiculo = {
    velocidade = 0,
    maxVelocidade = 200
}

function Veiculo:new()
    local obj = {}
    setmetatable(obj, {__index = self})
    return obj
end

function Veiculo:acelerar(valor)
    self.velocidade = math.min(
        self.velocidade + valor,
        self.maxVelocidade
    )
end

-- Classe filha
local Carro = {}
setmetatable(Carro, {__index = Veiculo})

function Carro:new()
    local obj = Veiculo:new()
    setmetatable(obj, {__index = self})
    obj.portas = 4
    return obj
end

-- Uso
local carro = Carro:new()
carro:acelerar(50)
```

### 3. Encapsulamento
```lua
-- Classe com privado
local Banco = {}
local saldos = {}  -- privado

function Banco:new(dono)
    local obj = {}
    setmetatable(obj, {__index = self})
    obj.dono = dono
    saldos[dono] = 0
    return obj
end

function Banco:getSaldo()
    return saldos[self.dono]
end

function Banco:depositar(valor)
    if valor <= 0 then return false end
    saldos[self.dono] = saldos[self.dono] + valor
    return true
end

-- Uso
local conta = Banco:new("João")
conta:depositar(1000)
print(conta:getSaldo())
```

## Exemplos Práticos

### 1. Sistema de Inventário
```lua
-- Classe Item
local Item = {
    peso = 0,
    valor = 0
}

function Item:new(nome, peso, valor)
    local obj = {}
    setmetatable(obj, {__index = self})
    obj.nome = nome
    obj.peso = peso
    obj.valor = valor
    return obj
end

-- Classe Inventário
local Inventario = {
    pesoMax = 100
}

function Inventario:new(dono)
    local obj = {}
    setmetatable(obj, {__index = self})
    obj.dono = dono
    obj.items = {}
    obj.pesoAtual = 0
    return obj
end

function Inventario:addItem(item)
    if self.pesoAtual + item.peso > self.pesoMax then
        return false, "Muito pesado"
    end
    
    table.insert(self.items, item)
    self.pesoAtual = self.pesoAtual + item.peso
    return true
end

-- Uso
local espada = Item:new("Espada", 5, 100)
local inv = Inventario:new("João")
inv:addItem(espada)
```

### 2. Sistema de Veículos
```lua
-- Classe base
local Veiculo = {
    vida = 1000,
    velocidade = 0
}

function Veiculo:new(modelo)
    local obj = {}
    setmetatable(obj, {__index = self})
    obj.modelo = modelo
    obj.elemento = createVehicle(modelo, 0, 0, 3)
    return obj
end

function Veiculo:destruir()
    if isElement(self.elemento) then
        destroyElement(self.elemento)
    end
end

-- Classe Carro
local Carro = setmetatable({}, {__index = Veiculo})
Carro.maxVelocidade = 200

function Carro:new(modelo)
    local obj = Veiculo:new(modelo)
    setmetatable(obj, {__index = self})
    return obj
end

function Carro:turbo()
    self.velocidade = self.velocidade + 50
end

-- Classe Moto
local Moto = setmetatable({}, {__index = Veiculo})
Moto.maxVelocidade = 250

function Moto:new(modelo)
    local obj = Veiculo:new(modelo)
    setmetatable(obj, {__index = self})
    return obj
end

function Moto:empinar()
    -- código de empinar
end

-- Uso
local carro = Carro:new(411)
local moto = Moto:new(461)
```

### 3. Sistema de Missões
```lua
-- Classe base
local Missao = {
    completa = false,
    recompensa = 0
}

function Missao:new(nome, recompensa)
    local obj = {}
    setmetatable(obj, {__index = self})
    obj.nome = nome
    obj.recompensa = recompensa
    return obj
end

function Missao:completar(player)
    if self.completa then return false end
    self.completa = true
    self:darRecompensa(player)
    return true
end

function Missao:darRecompensa(player)
    givePlayerMoney(player, self.recompensa)
end

-- Missão de Matar
local MissaoMatar = setmetatable({}, {__index = Missao})

function MissaoMatar:new(nome, alvo, recompensa)
    local obj = Missao:new(nome, recompensa)
    setmetatable(obj, {__index = self})
    obj.alvo = alvo
    obj.mortes = 0
    return obj
end

function MissaoMatar:onMorte(vitima)
    if vitima == self.alvo then
        self.mortes = self.mortes + 1
        if self.mortes >= 1 then
            self:completar()
        end
    end
end

-- Uso
local missao = MissaoMatar:new("Eliminar", "Bandido", 1000)
addEventHandler("onPlayerWasted", root,
    function(vitima)
        missao:onMorte(vitima)
    end
)
```

## Dicas Importantes

### 1. Organização
```lua
-- Um arquivo por classe
-- veiculo.lua
local Veiculo = {}
return Veiculo

-- carro.lua
local Veiculo = require("veiculo")
local Carro = setmetatable({}, {__index = Veiculo})
return Carro
```

### 2. Performance
```lua
-- Cache de métodos
local Jogador = {}
local _morrer = Jogador.morrer  -- cache

function Jogador:dano(valor)
    self.vida = self.vida - valor
    if self.vida <= 0 then
        _morrer(self)  -- mais rápido
    end
end
```

### 3. Convenções
```lua
-- Nomes de classe com maiúscula
local Player = {}
local Veiculo = {}
local Missao = {}

-- Métodos com minúscula
function Player:mover() end
function Veiculo:acelerar() end
function Missao:completar() end
```

## Conclusão

OOP é importante porque:
- Organiza código
- Reutiliza código
- Facilita manutenção
- Melhora legibilidade

Lembra:
- Use classes com sentido
- Planeje a herança
- Mantenha simples
- Código limpo é código feliz!
