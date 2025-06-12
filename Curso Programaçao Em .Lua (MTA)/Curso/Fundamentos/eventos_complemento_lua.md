# Eventos em Lua - MTA

Vamos aprender sobre eventos no MTA.

## O que são Eventos?

Eventos são como sinais que avisam quando algo acontece no jogo:
- Player entrou? Evento!
- Alguém atirou? Evento!
- Carro explodiu? Evento!

## Tipos de Eventos

### 1. Eventos do MTA
São eventos que já vêm prontos:

```lua
-- Quando player entra
addEventHandler("onPlayerJoin", root, function(player)
    outputChatBox("Bem vindo " .. getPlayerName(player) .. "!")
end)

-- Quando player morre
addEventHandler("onPlayerWasted", root, function(player, killer)
    if killer then
        outputChatBox(getPlayerName(killer) .. " detonou " .. getPlayerName(player) .. "!")
    end
end)
```

### 2. Eventos Customizados
Você pode criar seus próprios eventos:

```lua
-- Criar evento
addEvent("onPlayerLevelUp", true)

-- Disparar evento
triggerEvent("onPlayerLevelUp", player, novoLevel)

-- Escutar evento
addEventHandler("onPlayerLevelUp", root, function(player, level)
    outputChatBox(getPlayerName(player) .. " subiu pro level " .. level .. "!")
end)
```

## Como Usar Eventos

### 1. Adicionar Handler
```lua
function onPlayerEnterCar(player, seat, jacked)
    if seat == 0 then -- Motorista
        outputChatBox("Vrum vrum!", player)
    end
end
addEventHandler("onVehicleEnter", root, onPlayerEnterCar)
```

### 2. Remover Handler
```lua
function tempHandler()
    -- Faz algo
end

addEventHandler("onResourceStart", resourceRoot, tempHandler)
removeEventHandler("onResourceStart", resourceRoot, tempHandler)
```

### 3. Trigger Events
```lua
-- Server -> Client
triggerClientEvent(player, "onShowMessage", player, "Oi client!")

-- Client -> Server
triggerServerEvent("onRequestItem", localPlayer, "espada")

-- Local
triggerEvent("onLocalStuff", source, data)
```

## Exemplos Práticos

### Sistema de Conquistas
```lua
-- Criar eventos
addEvent("onPlayerAchievement", true)
addEvent("onAchievementComplete", true)

-- Sistema de conquistas
local Conquistas = {
    ["PrimeiroLogin"] = {
        nome = "Primeiro Login",
        desc = "Bem vindo ao servidor!",
        pontos = 10
    },
    ["Matador"] = {
        nome = "Matador",
        desc = "Mate 10 players",
        pontos = 50
    }
}

-- Dar conquista
function darConquista(player, conquista)
    if not Conquistas[conquista] then return end
    
    local dados = Conquistas[conquista]
    triggerEvent("onPlayerAchievement", player, dados)
    
    outputChatBox("Conquista: " .. dados.nome, player)
    outputChatBox(dados.desc, player)
    outputChatBox("+" .. dados.pontos .. " pontos!", player)
end

-- Exemplo de uso
addEventHandler("onPlayerJoin", root, function(player)
    darConquista(player, "PrimeiroLogin")
end)
```

### Sistema de Missões
```lua
-- Eventos
addEvent("onMissionStart", true)
addEvent("onMissionComplete", true)
addEvent("onMissionFail", true)

-- Missão exemplo
function iniciarMissaoZumbi(player)
    if not isElement(player) then return end
    
    -- Config da missão
    local missao = {
        nome = "Apocalipse Zumbi",
        zumbis = 10,
        tempo = 300, -- 5 minutos
        premio = 5000
    }
    
    -- Avisa início
    triggerEvent("onMissionStart", player, missao)
    
    -- Timer pra acabar
    setTimer(function()
        if getZumbisMortos(player) >= missao.zumbis then
            -- Completou!
            triggerEvent("onMissionComplete", player, missao)
            givePlayerMoney(player, missao.premio)
        else
            -- Falhou...
            triggerEvent("onMissionFail", player, missao)
        end
    end, missao.tempo * 1000, 1)
end

-- Handlers
addEventHandler("onMissionStart", root, function(player, missao)
    outputChatBox("Missão: " .. missao.nome, player)
    outputChatBox("Mate " .. missao.zumbis .. " zumbis!", player)
    outputChatBox("Tempo: " .. missao.tempo .. " segundos", player)
end)

addEventHandler("onMissionComplete", root, function(player, missao)
    outputChatBox("Missão completa!", player)
    outputChatBox("Ganhou $" .. missao.premio, player)
end)

addEventHandler("onMissionFail", root, function(player, missao)
    outputChatBox("Missão falhou!", player)
end)
```

### Sistema de Notificações
```lua
-- Eventos
addEvent("onNotification", true)

-- Tipos de notificação
local TipoNotificacao = {
    INFO = {cor = "#3498db", icone = "i"},
    SUCESSO = {cor = "#2ecc71", icone = "v"},
    ERRO = {cor = "#e74c3c", icone = "x"},
    AVISO = {cor = "#f1c40f", icone = "!"}
}

-- Função helper
function notificar(player, tipo, mensagem)
    if not TipoNotificacao[tipo] then
        tipo = "INFO"
    end
    
    local dados = TipoNotificacao[tipo]
    triggerEvent("onNotification", player, {
        texto = mensagem,
        cor = dados.cor,
        icone = dados.icone
    })
end

-- Exemplos de uso
notificar(player, "SUCESSO", "Item comprado!")
notificar(player, "ERRO", "Dinheiro insuficiente!")
notificar(player, "AVISO", "Você está perdendo vida!")
```

## Dicas Importantes

### 1. Cancele Eventos se Precisar
```lua
addEventHandler("onVehicleStartEnter", root, function(player, seat)
    if getElementHealth(player) <= 20 then
        cancelEvent() -- Não deixa entrar
        outputChatBox("Você está muito machucado!", player)
    end
end)
```

### 2. Use Source
```lua
addEventHandler("onPlayerDamage", root, function(attacker, weapon, loss)
    local player = source -- source é quem tomou dano
    outputChatBox("Você tomou " .. loss .. " de dano!", player)
end)
```

### 3. Prioridade de Eventos
```lua
-- + prioridade (roda primeiro)
addEventHandler("onPlayerJoin", root, func1, true, "high")

-- prioridade normal
addEventHandler("onPlayerJoin", root, func2)

-- - prioridade (roda por último)
addEventHandler("onPlayerJoin", root, func3, true, "low")
```

## Conclusão

Eventos são importantes porque:
- Fazem a comunicação do jogo
- Deixam tudo organizado
- Facilitam criar sistemas legais

Lembra:
- Use eventos do MTA quando puder
- Crie eventos próprios quando precisar
- Organize bem os handlers
