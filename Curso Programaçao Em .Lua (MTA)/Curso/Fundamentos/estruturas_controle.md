# Estruturas de Controle em Lua

Vamos aprender a controlar o fluxo do seu código?

## if, elseif e else

### Básico
```lua
local vida = getElementHealth(player)

if vida < 20 then
    outputChatBox("Cuidado! Vida baixa!", player, 255, 0, 0)
elseif vida < 50 then
    outputChatBox("Vida média!", player, 255, 255, 0)
else
    outputChatBox("Vida boa!", player, 0, 255, 0)
end
```

### Com and/or
```lua
-- Checa várias coisas de uma vez
if isElement(player) and getElementHealth(player) > 0 and not isPedDead(player) then
    outputChatBox("Player está vivo!", player)
end

-- Valor padrão maneiro
local dano = getDano() or 10 -- Se getDano() for nil, usa 10
```

## while e repeat

### while
```lua
local tempo = 10
while tempo > 0 do
    outputChatBox("Tempo: " .. tempo)
    tempo = tempo - 1
    wait(1000) -- Espera 1 segundo
end
outputChatBox("Tempo acabou!")
```

### repeat
```lua
local tentativas = 0
repeat
    tentativas = tentativas + 1
    local sucesso = tentarConectar()
until sucesso or tentativas >= 3
```

## for

### Numérico
```lua
-- Conta de 1 a 10
for i = 1, 10 do
    outputChatBox("Número: " .. i)
end

-- Conta de 10 a 1
for i = 10, 1, -1 do
    outputChatBox("Contagem: " .. i)
end
```

### Iteração em Tabelas
```lua
local itens = {
    {nome = "Espada", dano = 10},
    {nome = "Escudo", defesa = 5},
    {nome = "Poção", cura = 20}
}

-- Mostra todos os itens
for i, item in ipairs(itens) do
    outputChatBox(i .. ": " .. item.nome)
end

-- Usando pairs pra tabelas não sequenciais
local jogadores = {}
for id, player in pairs(getElementsByType("player")) do
    jogadores[getPlayerName(player)] = player
end
```

## break e return

### break
```lua
-- Para o loop quando achar
for _, player in ipairs(getElementsByType("player")) do
    if getPlayerName(player) == "João" then
        outputChatBox("Achei o João!")
        break -- Sai do loop
    end
end
```

### return
```lua
function procurarPlayer(nome)
    for _, player in ipairs(getElementsByType("player")) do
        if getPlayerName(player) == nome then
            return player -- Achou e já retorna
        end
    end
    return false -- Não achou
end
```

## Exemplos Práticos

### Sistema de Missão
```lua
function iniciarMissao(player)
    if not isElement(player) then
        return false, "Player inválido"
    end
    
    -- Checa requisitos
    local level = getPlayerLevel(player)
    if level < 10 then
        return false, "Precisa ser level 10+"
    end
    
    -- Dá os objetivos
    local objetivos = {
        "Mate 10 zumbis",
        "Colete 5 itens",
        "Sobreviva 5 minutos"
    }
    
    for i, objetivo in ipairs(objetivos) do
        outputChatBox(i .. ": " .. objetivo, player)
    end
    
    return true
end
```

### Sistema de Loja
```lua
function comprarItem(player, item)
    -- Validações
    if not player or not item then
        return false, "Dados inválidos"
    end
    
    -- Checa preço
    local precos = {
        espada = 1000,
        escudo = 500,
        pocao = 100
    }
    
    local preco = precos[item]
    if not preco then
        return false, "Item não existe"
    end
    
    -- Checa dinheiro
    local dinheiro = getPlayerMoney(player)
    if dinheiro < preco then
        return false, "Dinheiro insuficiente"
    end
    
    -- Faz a compra
    takePlayerMoney(player, preco)
    darItem(player, item)
    
    outputChatBox("Comprou " .. item .. " por $" .. preco, player)
    return true
end
```

### Sistema de Ranking
```lua
function atualizarRanking()
    local players = getElementsByType("player")
    local ranking = {}
    
    -- Pega dados
    for _, player in ipairs(players) do
        table.insert(ranking, {
            nome = getPlayerName(player),
            kills = getPlayerKills(player),
            deaths = getPlayerDeaths(player)
        })
    end
    
    -- Ordena
    table.sort(ranking, function(a, b)
        return a.kills > b.kills
    end)
    
    -- Mostra top 3
    for i = 1, math.min(3, #ranking) do
        local player = ranking[i]
        outputChatBox(string.format(
            "%d° - %s: %d kills",
            i, player.nome, player.kills
        ))
    end
end
```

## Dicas Importantes

1. **Evite Nesting Profundo**
```lua
-- Ruim
if a then
    if b then
        if c then
            -- Muito aninhado
        end
    end
end

-- Melhor
if not a then return end
if not b then return end
if not c then return end
-- Código aqui
```

2. **Use Early Returns**
```lua
function processarPlayer(player)
    -- Checa tudo no início
    if not isElement(player) then return end
    if getElementHealth(player) <= 0 then return end
    if isPedInVehicle(player) then return end
    
    -- Código principal aqui
end
```

3. **Simplifique Condições**
```lua
-- Ruim
if condicao == true then
    return true
else
    return false
end

-- Melhor
return condicao
```

## Conclusão

Estruturas de controle são suas ferramentas para:
- Tomar decisões
- Repetir ações
- Organizar código

Lembre-se:
- Mantenha simples
- Evite muitos aninhamentos
- Use early returns
- Código limpo é código feliz
