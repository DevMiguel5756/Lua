# Módulos em Lua

E aí dev! Vamo aprender a organizar seu código usando módulos?

## O que são Módulos?

Módulos são arquivos Lua que:
- Agrupam código relacionado
- Podem ser reutilizados
- Deixam o código organizado

## Criando Módulos

### Módulo Básico
```lua
-- arquivo: utils.lua
local Utils = {}

function Utils.somar(a, b)
    return a + b
end

function Utils.multiplicar(a, b)
    return a * b
end

return Utils

-- usar
local utils = require("utils")
print(utils.somar(2, 3)) -- 5
```

### Módulo com Estado
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

### Módulo com Privado
```lua
-- arquivo: banco.lua
local Banco = {}

-- Funções privadas
local function validarValor(valor)
    return type(valor) == "number" and valor > 0
end

-- Funções públicas
function Banco.depositar(conta, valor)
    if not validarValor(valor) then
        return false, "Valor inválido"
    end
    conta.saldo = (conta.saldo or 0) + valor
    return true
end

return Banco
```

## Usando Módulos

### require
```lua
local utils = require("utils")
local contador = require("contador")
local banco = require("banco")

-- Usa funções
utils.somar(1, 2)
contador.incrementar()
banco.depositar(conta, 100)
```

### package.path
```lua
-- Adiciona pasta aos caminhos
package.path = package.path .. ";scripts/?.lua"

-- Agora pode carregar de scripts/
local modulo = require("scripts.meumodulo")
```

## Exemplos Práticos

### Sistema de Inventário
```lua
-- arquivo: inventario.lua
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

return Inventario

-- usar
local inv = require("inventario")
inv.adicionar("espada")
```

### Sistema de Loja
```lua
-- arquivo: loja.lua
local Loja = {}

-- Dados
local itens = {
    espada = {preco = 100},
    escudo = {preco = 50},
    pocao = {preco = 10}
}

-- Funções
function Loja.getPreco(item)
    local info = itens[item]
    return info and info.preco
end

function Loja.comprar(player, item)
    local preco = Loja.getPreco(item)
    if not preco then
        return false, "Item não existe"
    end
    
    if getPlayerMoney(player) < preco then
        return false, "Dinheiro insuficiente"
    end
    
    takePlayerMoney(player, preco)
    givePlayerItem(player, item)
    return true
end

return Loja

-- usar
local loja = require("loja")
loja.comprar(player, "espada")
```

### Sistema de Configuração
```lua
-- arquivo: config.lua
local Config = {
    -- Defaults
    maxPlayers = 32,
    gamemode = "DM",
    mapName = "Los Santos"
}

-- Carrega do arquivo
local function carregar()
    local arquivo = fileOpen("config.json")
    if not arquivo then return end
    
    local dados = fileRead(arquivo, fileGetSize(arquivo))
    fileClose(arquivo)
    
    local config = fromJSON(dados)
    if type(config) == "table" then
        -- Atualiza valores
        for k, v in pairs(config) do
            Config[k] = v
        end
    end
end

-- Salva no arquivo
local function salvar()
    local arquivo = fileCreate("config.json")
    if not arquivo then return end
    
    fileWrite(arquivo, toJSON(Config))
    fileClose(arquivo)
end

-- Carrega ao iniciar
carregar()

-- Interface pública
return setmetatable({}, {
    __index = Config,
    __newindex = function(t, k, v)
        Config[k] = v
        salvar()
    end
})

-- usar
local config = require("config")
print(config.maxPlayers) -- 32
config.mapName = "Vice City" -- Salva automaticamente
```

## Dicas Importantes

### 1. Organize por Função
```lua
-- player/
--   init.lua
--   inventory.lua
--   skills.lua
--   stats.lua

-- vehicle/
--   init.lua
--   handling.lua
--   tuning.lua
```

### 2. Use require com Cuidado
```lua
-- Ruim: carrega várias vezes
function onPlayerJoin()
    local utils = require("utils")
end

-- Melhor: carrega uma vez
local utils = require("utils")
function onPlayerJoin()
    -- usa utils
end
```

### 3. Evite Variáveis Globais
```lua
-- Ruim
CONFIGURACAO = {
    -- dados
}

-- Melhor
local Configuracao = {
    -- dados
}
return Configuracao
```

## Conclusão

Módulos são importantes porque:
- Organizam código
- Facilitam manutenção
- Evitam conflitos

Lembra:
- Organize bem os arquivos
- Use nomes claros
- Documente interfaces
- Código limpo é código feliz
