# Serialização em Lua

E aí dev! Vamo aprender sobre serialização? É como transformar dados em texto e vice-versa!

## O que é Serialização?

Serialização é o processo de converter dados (como tabelas) em texto pra poder:
- Salvar em arquivos
- Enviar pela rede
- Guardar em banco de dados

## Funções Básicas no MTA

### toJSON e fromJSON
```lua
-- Convertendo pra JSON
local dados = {
    nome = "João",
    vida = 100,
    itens = {"espada", "escudo"}
}

local json = toJSON(dados)
print(json)  -- {"nome":"João","vida":100,"itens":["espada","escudo"]}

-- Voltando do JSON
local voltou = fromJSON(json)
print(voltou.nome)  -- João
```

### Salvando em Arquivo
```lua
-- Salvando
function salvarDados(dados, arquivo)
    local json = toJSON(dados)
    local file = fileCreate(arquivo)
    
    if file then
        fileWrite(file, json)
        fileClose(file)
        return true
    end
    return false
end

-- Carregando
function carregarDados(arquivo)
    local file = fileOpen(arquivo)
    
    if file then
        local json = fileRead(file, fileGetSize(file))
        fileClose(file)
        return fromJSON(json)
    end
    return nil
end

-- Uso
local dados = {
    jogadores = {
        ["João"] = {nivel = 10},
        ["Maria"] = {nivel = 15}
    }
}

salvarDados(dados, "dados.json")
local carregado = carregarDados("dados.json")
```

## Exemplos Práticos

### 1. Sistema de Save
```lua
-- Dados do jogador
function salvarJogador(player)
    local dados = {
        vida = getElementHealth(player),
        colete = getPedArmor(player),
        dinheiro = getPlayerMoney(player),
        posicao = {getElementPosition(player)},
        armas = {}
    }
    
    -- Salva armas
    for slot = 0, 12 do
        local arma = getPedWeapon(player, slot)
        local municao = getPedTotalAmmo(player, slot)
        
        if arma > 0 then
            dados.armas[slot] = {
                id = arma,
                municao = municao
            }
        end
    end
    
    -- Salva no arquivo
    local conta = getAccountName(getPlayerAccount(player))
    return salvarDados(dados, "saves/" .. conta .. ".json")
end

-- Carrega dados
function carregarJogador(player)
    local conta = getAccountName(getPlayerAccount(player))
    local dados = carregarDados("saves/" .. conta .. ".json")
    
    if dados then
        -- Restaura status
        setElementHealth(player, dados.vida)
        setPedArmor(player, dados.colete)
        setPlayerMoney(player, dados.dinheiro)
        
        -- Restaura posição
        setElementPosition(player,
            dados.posicao[1],
            dados.posicao[2],
            dados.posicao[3]
        )
        
        -- Restaura armas
        for slot, arma in pairs(dados.armas) do
            giveWeapon(player, arma.id, arma.municao)
        end
        
        return true
    end
    return false
end
```

### 2. Sistema de Configuração
```lua
local Config = {
    -- Padrões
    maxPlayers = 32,
    gamemode = "DM",
    mapName = "Los Santos",
    
    -- Carrega config
    carregar = function()
        local dados = carregarDados("config.json")
        if dados then
            for k, v in pairs(dados) do
                Config[k] = v
            end
        end
    end,
    
    -- Salva config
    salvar = function()
        local dados = {}
        for k, v in pairs(Config) do
            if type(v) ~= "function" then
                dados[k] = v
            end
        end
        return salvarDados(dados, "config.json")
    end
}

-- Carrega ao iniciar
addEventHandler("onResourceStart", resourceRoot,
    function()
        Config.carregar()
    end
)
```

### 3. Sistema de Ranking
```lua
local Ranking = {
    jogadores = {},
    
    adicionar = function(nome, pontos)
        Ranking.jogadores[nome] = pontos
        Ranking.salvar()
    end,
    
    getPontos = function(nome)
        return Ranking.jogadores[nome] or 0
    end,
    
    getTop = function(limite)
        local top = {}
        for nome, pontos in pairs(Ranking.jogadores) do
            table.insert(top, {
                nome = nome,
                pontos = pontos
            })
        end
        
        table.sort(top, function(a, b)
            return a.pontos > b.pontos
        end)
        
        if limite then
            local limitado = {}
            for i = 1, math.min(limite, #top) do
                limitado[i] = top[i]
            end
            return limitado
        end
        
        return top
    end,
    
    salvar = function()
        return salvarDados(Ranking.jogadores, "ranking.json")
    end,
    
    carregar = function()
        local dados = carregarDados("ranking.json")
        if dados then
            Ranking.jogadores = dados
            return true
        end
        return false
    end
}

-- Carrega ao iniciar
addEventHandler("onResourceStart", resourceRoot,
    function()
        Ranking.carregar()
    end
)
```

## Dicas Importantes

### 1. Validação de Dados
```lua
function salvarSeguro(dados)
    -- Checa se é tabela
    if type(dados) ~= "table" then
        return false, "Dados inválidos"
    end
    
    -- Remove funções
    local limpo = {}
    for k, v in pairs(dados) do
        if type(v) ~= "function" then
            limpo[k] = v
        end
    end
    
    -- Tenta serializar
    local ok = pcall(function()
        toJSON(limpo)
    end)
    
    if not ok then
        return false, "Erro na serialização"
    end
    
    return true
end
```

### 2. Backup de Dados
```lua
function salvarComBackup(dados, arquivo)
    -- Tenta backup do anterior
    if fileExists(arquivo) then
        local backup = arquivo .. ".bak"
        fileCopy(arquivo, backup, true)
    end
    
    -- Salva novo
    return salvarDados(dados, arquivo)
end
```

### 3. Compressão
```lua
function salvarComprimido(dados, arquivo)
    local json = toJSON(dados)
    local comprimido = compressString(json)
    
    local file = fileCreate(arquivo)
    if file then
        fileWrite(file, comprimido)
        fileClose(file)
        return true
    end
    return false
end

function carregarComprimido(arquivo)
    local file = fileOpen(arquivo)
    if file then
        local comprimido = fileRead(file, fileGetSize(file))
        fileClose(file)
        
        local json = uncompressString(comprimido)
        return fromJSON(json)
    end
    return nil
end
```

## Conclusão

Serialização é importante porque:
- Salva dados do jogo
- Transfere informações
- Mantém configurações
- Guarda rankings

Lembra:
- Valide os dados
- Faça backup
- Trate erros
- Código limpo é código feliz
