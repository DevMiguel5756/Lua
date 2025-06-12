# Erros em Lua

E aí dev! Vamo aprender a lidar com erros no Lua?

## Tipos de Erros

### Erros de Sintaxe
```lua
-- Erro: faltou end
if true then
    print("oi")

-- Erro: faltou então
if true
    print("oi")
end
```

### Erros de Runtime
```lua
-- Erro: nil.alguma_coisa
local player = nil
print(player.name)

-- Erro: número + string
local total = 10 + "20"
```

### Erros de Lógica
```lua
-- Loop infinito
while true do
    print("socorro")
end

-- Condição errada
if player.health <= 0 then
    setElementHealth(player, 100) -- Deveria ser > 0
end
```

## Tratando Erros

### pcall
```lua
-- Função perigosa
local function funcaoPerigosa()
    error("Boom!")
end

-- Trata erro
local sucesso, erro = pcall(funcaoPerigosa)
if not sucesso then
    outputDebugString("Erro: " .. erro)
end
```

### xpcall
```lua
-- Handler de erro
local function handler(erro)
    outputDebugString("Erro: " .. erro)
    outputDebugString(debug.traceback())
end

-- Trata erro com stack trace
xpcall(funcaoPerigosa, handler)
```

### assert
```lua
function darItem(player, item)
    -- Checa parâmetros
    assert(isElement(player), "Player inválido")
    assert(type(item) == "string", "Item deve ser string")
    
    -- Código seguro aqui
end
```

## Exemplos Práticos

### Sistema de Banco
```lua
local function transferir(origem, destino, valor)
    -- Validações
    if not isElement(origem) or not isElement(destino) then
        return false, "Player inválido"
    end
    
    if type(valor) ~= "number" or valor <= 0 then
        return false, "Valor inválido"
    end
    
    -- Checa saldo
    local saldo = getPlayerMoney(origem)
    if saldo < valor then
        return false, "Saldo insuficiente"
    end
    
    -- Faz transferência
    local sucesso = pcall(function()
        takePlayerMoney(origem, valor)
        givePlayerMoney(destino, valor)
    end)
    
    if not sucesso then
        return false, "Erro na transferência"
    end
    
    return true
end
```

### Sistema de Save
```lua
local function salvarDados(player)
    if not isElement(player) then
        return false, "Player inválido"
    end
    
    -- Pega dados
    local dados = {
        vida = getElementHealth(player),
        dinheiro = getPlayerMoney(player),
        itens = getPlayerItems(player)
    }
    
    -- Salva com proteção
    local sucesso, erro = pcall(function()
        local arquivo = fileCreate("dados/" .. getPlayerName(player) .. ".json")
        fileWrite(arquivo, toJSON(dados))
        fileClose(arquivo)
    end)
    
    if not sucesso then
        outputDebugString("Erro ao salvar: " .. erro)
        return false, "Erro ao salvar dados"
    end
    
    return true
end
```

### Sistema de Plugins
```lua
local Plugins = {
    lista = {},
    
    carregar = function(self, nome)
        -- Tenta carregar
        local sucesso, plugin = pcall(function()
            return require("plugins/" .. nome)
        end)
        
        if not sucesso then
            outputDebugString("Erro ao carregar plugin: " .. plugin)
            return false
        end
        
        -- Valida plugin
        if type(plugin) ~= "table" then
            outputDebugString("Plugin inválido: " .. nome)
            return false
        end
        
        -- Guarda plugin
        self.lista[nome] = plugin
        
        -- Inicia se tiver init
        if plugin.init then
            local ok, erro = pcall(plugin.init)
            if not ok then
                outputDebugString("Erro ao iniciar plugin: " .. erro)
                return false
            end
        end
        
        return true
    end,
    
    descarregar = function(self, nome)
        local plugin = self.lista[nome]
        if not plugin then return false end
        
        -- Chama cleanup se tiver
        if plugin.cleanup then
            local ok, erro = pcall(plugin.cleanup)
            if not ok then
                outputDebugString("Erro ao limpar plugin: " .. erro)
            end
        end
        
        self.lista[nome] = nil
        return true
    end
}
```

## Dicas Importantes

### 1. Sempre Valide Entrada
```lua
function processarPlayer(player)
    -- Validações primeiro
    if not isElement(player) then
        return false, "Player inválido"
    end
    
    if getElementType(player) ~= "player" then
        return false, "Elemento não é player"
    end
    
    -- Código seguro depois
end
```

### 2. Use pcall em Código Perigoso
```lua
-- Carrega arquivo
local function carregarConfig()
    local sucesso, conteudo = pcall(function()
        local arquivo = fileOpen("config.json")
        local dados = fileRead(arquivo, fileGetSize(arquivo))
        fileClose(arquivo)
        return fromJSON(dados)
    end)
    
    if not sucesso then
        return false, "Erro ao carregar config"
    end
    
    return conteudo
end
```

### 3. Log de Erros
```lua
local function logErro(erro, info)
    -- Data e hora
    local tempo = os.date("%Y-%m-%d %H:%M:%S")
    
    -- Formata mensagem
    local msg = string.format("[%s] %s", tempo, erro)
    if info then
        msg = msg .. " | " .. tostring(info)
    end
    
    -- Salva
    local arquivo = fileOpen("erros.log", true)
    fileWrite(arquivo, msg .. "\n")
    fileClose(arquivo)
end
```

## Conclusão

Tratar erros é importante porque:
- Evita crashes
- Facilita debug
- Melhora experiência

Lembra:
- Valide entradas
- Use pcall
- Faça log de erros
- Código seguro é código feliz
