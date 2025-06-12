# Integrando Discord com seu Server MTA:SA

Fala dev! Bora aprender a usar o Discord pra deixar seu server mais seguro? É mais fácil q vc imagina!

## 1. Pq usar Discord?

### 1.1 Vantagens
- Logs em tempo real (vc sabe td q rola no server)
- Notificações importantes (tipo qnd tem hack)
- Comandos remotos (controla o server pelo Discord)
- Integração com staff (todo mundo fica por dentro)

### 1.2 Oq dá pra fazer?
1. **Logs de Tudo**
   - Qm entrou/saiu
   - Ações dos players
   - Comandos usados
   - Tentativas de hack

2. **Comandos Remotos**
   - Kick/ban players
   - Reinicia resources
   - Muda configs
   - Vê status do server

3. **Notificações**
   - Players reportados
   - Problemas no server
   - Avisos importantes
   - Logs de erro

## 2. Configurando Webhook

### 2.1 Criando Webhook
```lua
-- Config do webhook
local WEBHOOK = {
    url = "sua_url_do_webhook_aqui",
    name = "Server Logger",
    avatar = "url_do_avatar"
}

-- Função pra mandar msg
function sendDiscordMessage(message, color)
    if not WEBHOOK.url then return end
    
    -- Monta payload
    local payload = {
        username = WEBHOOK.name,
        avatar_url = WEBHOOK.avatar,
        embeds = {{
            description = message,
            color = color or 0x00ff00
        }}
    }
    
    -- Converte pra JSON
    local json = toJSON(payload)
    
    -- Manda request
    fetchRemote(WEBHOOK.url, {
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json"
        },
        postData = json,
        queueName = "discordWebhook"
    })
end
```

### 2.2 Sistema de Log
```lua
-- Cores pros logs
local LOG_COLORS = {
    join = 0x00ff00,    -- Verde
    quit = 0xff0000,    -- Vermelho
    chat = 0x0000ff,    -- Azul
    command = 0xff00ff, -- Rosa
    hack = 0xff0000     -- Vermelho
}

-- Handler de join
addEventHandler("onPlayerJoin", root, function()
    local name = getPlayerName(source)
    local ip = getPlayerIP(source)
    local serial = getPlayerSerial(source)
    
    sendDiscordMessage(string.format(
        "Player: %s\nIP: %s\nSerial: %s",
        name, ip, serial
    ), LOG_COLORS.join)
end)

-- Handler de quit
addEventHandler("onPlayerQuit", root, function(reason)
    local name = getPlayerName(source)
    
    sendDiscordMessage(string.format(
        "Player %s saiu (%s)",
        name, reason
    ), LOG_COLORS.quit)
end)

-- Handler de chat
addEventHandler("onPlayerChat", root, function(msg)
    local name = getPlayerName(source)
    
    sendDiscordMessage(string.format(
        "[CHAT] %s: %s",
        name, msg
    ), LOG_COLORS.chat)
end)
```

## 3. Bot do Discord

### 3.1 Comandos Básicos
```lua
-- Config do bot
local BOT_CONFIG = {
    token = "seu_token_aqui",
    prefix = "!",
    adminRole = "Admin"
}

-- Comandos disponíveis
local COMMANDS = {
    -- Kick player
    kick = {
        usage = "kick <player> [motivo]",
        func = function(author, player, reason)
            if not hasRole(author, BOT_CONFIG.adminRole) then
                return "Vc n tem permissão!"
            end
            
            local target = getPlayerFromName(player)
            if not target then
                return "Player n encontrado!"
            end
            
            kickPlayer(target, reason or "Kicked by Admin")
            return "Player kickado!"
        end
    },
    
    -- Status do server
    status = {
        usage = "status",
        func = function()
            local players = getElementsByType("player")
            local uptime = getServerUptime()
            
            return string.format(
                "Players: %d\nUptime: %s",
                #players,
                formatUptime(uptime)
            )
        end
    }
}
```

### 3.2 Sistema Anti-Hack
```lua
-- Config do anti-hack
local ANTIHACK = {
    webhook = "url_do_webhook_aqui",
    
    -- Tipos de hack
    HACKS = {
        speed = {
            name = "SpeedHack",
            threshold = 200 -- Velocidade máxima
        },
        health = {
            name = "HealthHack",
            threshold = 200 -- Vida máxima
        },
        weapon = {
            name = "WeaponHack",
            blacklist = {31, 38} -- Armas proibidas
        }
    }
}

-- Função pra reportar hack
function reportHack(player, hackType, details)
    local name = getPlayerName(player)
    local ip = getPlayerIP(player)
    local serial = getPlayerSerial(player)
    
    -- Manda pro Discord
    sendDiscordMessage(string.format(
        "**HACK DETECTADO**\n" ..
        "Player: %s\n" ..
        "Tipo: %s\n" ..
        "IP: %s\n" ..
        "Serial: %s\n" ..
        "Detalhes: %s",
        name, hackType, ip, serial, details
    ), LOG_COLORS.hack)
    
    -- Bane player
    banPlayer(player, false, false, true, nil,
        "Hack detectado: " .. hackType)
end

-- Checa velocidade
addEventHandler("onPlayerCommand", root, function()
    local veh = getPedOccupiedVehicle(source)
    if not veh then return end
    
    local speed = getElementSpeed(veh)
    if speed > ANTIHACK.HACKS.speed.threshold then
        reportHack(source, "SpeedHack",
            "Velocidade: " .. speed)
    end
end)

-- Checa vida
addEventHandler("onPlayerDamage", root, function()
    local health = getElementHealth(source)
    if health > ANTIHACK.HACKS.health.threshold then
        reportHack(source, "HealthHack",
            "Vida: " .. health)
    end
end)

-- Checa armas
addEventHandler("onPlayerWeaponSwitch", root, 
function(prevSlot, newSlot)
    local weapon = getPedWeapon(source, newSlot)
    
    -- Checa armas proibidas
    for _, banned in ipairs(ANTIHACK.HACKS.weapon.blacklist) do
        if weapon == banned then
            reportHack(source, "WeaponHack",
                "Arma: " .. weapon)
            break
        end
    end
end)
```

## 4. Dicas Importantes

### 4.1 Segurança
1. **Proteja seus Tokens**
   - N deixa público
   - Usa env vars
   - Troca se vazar

2. **Permissões**
   - Define bem os cargos
   - Limita oq cada um pode fazer
   - Revisa permissões

3. **Rate Limiting**
   - Limita requests
   - Evita spam
   - Protege API

### 4.2 Boas Práticas
1. **Logs Úteis**
   - Guarda info importante
   - Formata bem as msg
   - Usa cores diferentes

2. **Comandos Claros**
   - Nome fácil
   - Explica oq faz
   - Mostra erro qnd dá ruim

3. **Anti-Hack Eficiente**
   - Checa td q é importante
   - Bane qm tá usando hack
   - Avisa a staff
