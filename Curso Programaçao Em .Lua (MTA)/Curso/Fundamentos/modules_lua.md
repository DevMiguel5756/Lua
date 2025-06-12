# Módulos em Lua

E aí dev! Vamo aprender sobre módulos em Lua? São super úteis pra organizar seu código!

## O que são Módulos?

São arquivos que contêm código que pode ser reusado em outros lugares. Tipo uma biblioteca de funções!

## Criando Módulos

### 1. Módulo Básico
```lua
-- arquivo: utils.lua
local Utils = {}

function Utils.print(msg)
    outputDebugString(msg)
end

function Utils.log(tipo, msg)
    Utils.print(string.format("[%s] %s", tipo, msg))
end

return Utils
```

### 2. Módulo com Estado
```lua
-- arquivo: contador.lua
local Contador = {
    valor = 0
}

function Contador.incrementar()
    Contador.valor = Contador.valor + 1
    return Contador.valor
end

function Contador.resetar()
    Contador.valor = 0
end

return Contador
```

### 3. Módulo com Privado
```lua
-- arquivo: banco.lua
local Banco = {}

-- Funções privadas
local function validarValor(valor)
    return type(valor) == "number" and valor > 0
end

-- Funções públicas
function Banco.depositar(player, valor)
    if not validarValor(valor) then
        return false, "Valor inválido"
    end
    
    local saldo = getPlayerMoney(player)
    setPlayerMoney(player, saldo + valor)
    return true
end

return Banco
```

## Usando Módulos

### 1. Require
```lua
-- Carrega módulo
local utils = require("utils")
utils.print("Teste")

local contador = require("contador")
contador.incrementar()  -- 1
contador.incrementar()  -- 2
```

### 2. Múltiplos Módulos
```lua
-- Carrega vários
local utils = require("utils")
local banco = require("banco")
local contador = require("contador")

-- Usa juntos
utils.log("BANCO", "Iniciando...")
banco.depositar(player, 1000)
contador.incrementar()
```

## Exemplos Práticos

### 1. Sistema de Inventário
```lua
-- arquivo: inventario.lua
local Inventario = {}

function Inventario.addItem(player, item)
    local items = getElementData(player, "items") or {}
    if #items >= 20 then
        return false, "Inventário cheio"
    end
    
    table.insert(items, item)
    setElementData(player, "items", items)
    return true
end

function Inventario.removeItem(player, index)
    local items = getElementData(player, "items") or {}
    if not items[index] then
        return false, "Item não existe"
    end
    
    table.remove(items, index)
    setElementData(player, "items", items)
    return true
end

return Inventario

-- arquivo: main.lua
local inv = require("inventario")
inv.addItem(player, {nome = "Espada", dano = 10})
```

### 2. Sistema de Veículos
```lua
-- arquivo: veiculos.lua
local Veiculos = {}

function Veiculos.criar(modelo, x, y, z)
    local veiculo = createVehicle(modelo, x, y, z)
    if not veiculo then
        return false, "Falha ao criar"
    end
    
    setElementHealth(veiculo, 1000)
    setVehicleDamageProof(veiculo, false)
    return veiculo
end

function Veiculos.destruir(veiculo)
    if isElement(veiculo) then
        destroyElement(veiculo)
        return true
    end
    return false, "Veículo não existe"
end

return Veiculos

-- arquivo: main.lua
local veiculos = require("veiculos")
local carro = veiculos.criar(411, 0, 0, 3)
```

### 3. Sistema de Combate
```lua
-- arquivo: combate.lua
local Combate = {}

function Combate.dano(player, atacante, dano)
    if not isElement(player) or not isElement(atacante) then
        return false, "Player inválido"
    end
    
    local vida = getElementHealth(player)
    setElementHealth(player, vida - dano)
    
    if vida - dano <= 0 then
        Combate.morte(player, atacante)
    end
    return true
end

function Combate.morte(player, killer)
    killPed(player)
    setTimer(function()
        Combate.respawn(player)
    end, 5000, 1)
end

return Combate

-- arquivo: main.lua
local combate = require("combate")
addEventHandler("onPlayerDamage", root,
    function(atacante, arma, corpo, dano)
        combate.dano(source, atacante, dano)
    end
)
```

## Dicas Importantes

### 1. Organização
```lua
-- Um módulo por arquivo
-- inventario.lua
local Inventario = {}
return Inventario

-- veiculos.lua
local Veiculos = {}
return Veiculos

-- combate.lua
local Combate = {}
return Combate
```

### 2. Performance
```lua
-- Cache de módulos
local inv = require("inventario")
local veiculos = require("veiculos")

-- Melhor que require toda hora
function onPlayerJoin()
    inv.addItem(source, {nome = "Kit", tipo = "inicial"})
    veiculos.criar(411, 0, 0, 3)
end
```

### 3. Dependências
```lua
-- Módulo que usa outro
local utils = require("utils")
local Banco = {}

function Banco.depositar(player, valor)
    if not valor or valor <= 0 then
        utils.log("ERRO", "Valor inválido")
        return false
    end
    return true
end

return Banco
```

## Conclusão

Módulos são importantes porque:
- Organizam código
- Evitam conflitos
- Facilitam reuso
- Melhoram manutenção

Lembra:
- Um módulo por arquivo
- Cache os módulos
- Cuide das dependências
- Código limpo é código feliz!
