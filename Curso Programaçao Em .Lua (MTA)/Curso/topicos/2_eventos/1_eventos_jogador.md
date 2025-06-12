# Eventos de Jogador no MTA:SA

## Níveis de Conhecimento

### 1. Iniciante
#### O que são eventos de jogador?
São acontecimentos relacionados às ações dos jogadores que você pode detectar e responder, como:
- Jogador conectar/desconectar
- Jogador morrer/renascer
- Jogador usar comando
- Jogador chatear
- E muito mais!

#### Eventos Básicos
```lua
-- Conexão e Desconexão
addEventHandler("onPlayerJoin", root,
    function()
        outputChatBox("Bem vindo, " .. getPlayerName(source))
    end
)

addEventHandler("onPlayerQuit", root,
    function(quitType)
        outputChatBox(getPlayerName(source) .. " saiu (" .. quitType .. ")")
    end
)

-- Morte e Respawn
addEventHandler("onPlayerWasted", root,
    function(killer)
        if killer then
            outputChatBox(getPlayerName(killer) .. " matou " .. getPlayerName(source))
        end
    end
)
```

### 2. Intermediário
#### Sistema de Eventos Personalizados
```lua
-- Criar evento personalizado
addEvent("onPlayerLevelUp", true)
addEvent("onPlayerAchievement", true)

-- Handler para level up
addEventHandler("onPlayerLevelUp", root,
    function(oldLevel, newLevel)
        -- Notifica todos
        outputChatBox(getPlayerName(source) .. " subiu para nível " .. newLevel)
        
        -- Recompensas
        if newLevel % 5 == 0 then  -- A cada 5 níveis
            givePlayerMoney(source, newLevel * 1000)
        end
    end
)

-- Trigger do evento
function playerLevelUp(player, newLevel)
    local oldLevel = getElementData(player, "level") or 1
    setElementData(player, "level", newLevel)
    
    triggerEvent("onPlayerLevelUp", player, oldLevel, newLevel)
end
```

### 3. Avançado
#### Sistema de Eventos Complexos
```lua
local EventManager = {
    eventos = {},
    handlers = {},
    
    -- Registro de eventos
    registrarEvento = function(self, nome, config)
        if not self.eventos[nome] then
            addEvent(nome, true)
            self.eventos[nome] = config
            
            -- Registra handler padrão
            if config.handler then
                self:registrarHandler(nome, config.handler)
            end
        end
    end,
    
    -- Registro de handlers
    registrarHandler = function(self, nome, handler)
        if not self.handlers[nome] then
            self.handlers[nome] = {}
        end
        
        table.insert(self.handlers[nome], handler)
        addEventHandler(nome, root, handler)
    end,
    
    -- Disparo de eventos
    dispararEvento = function(self, nome, source, ...)
        if self.eventos[nome] then
            -- Verificações pré-evento
            if self.eventos[nome].preCheck then
                if not self.eventos[nome].preCheck(source, ...) then
                    return false
                end
            end
            
            -- Dispara evento
            triggerEvent(nome, source, ...)
            
            -- Ações pós-evento
            if self.eventos[nome].postAction then
                self.eventos[nome].postAction(source, ...)
            end
            
            return true
        end
        return false
    end
}

-- Exemplo de uso
EventManager:registrarEvento("onPlayerAchievement", {
    preCheck = function(player, achievement)
        -- Verifica se jogador já tem conquista
        local achievements = getElementData(player, "achievements") or {}
        return not achievements[achievement]
    end,
    
    handler = function(achievement)
        local player = source
        -- Salva conquista
        local achievements = getElementData(player, "achievements") or {}
        achievements[achievement] = true
        setElementData(player, "achievements", achievements)
        
        -- Notifica
        outputChatBox(getPlayerName(player) .. " conseguiu: " .. achievement)
    end,
    
    postAction = function(player, achievement)
        -- Recompensa
        local recompensas = {
            ["Primeiro Login"] = 1000,
            ["100 Kills"] = 5000,
            ["Veterano"] = 10000
        }
        
        if recompensas[achievement] then
            givePlayerMoney(player, recompensas[achievement])
        end
    end
})
```

### 4. Expert
#### Sistema Completo de Eventos
```lua
local PlayerEventSystem = {
    -- Configuração
    config = {
        logEvents = true,
        broadcastEvents = true,
        saveStats = true
    },
    
    -- Cache de dados
    cache = {
        playerStats = {},
        eventHistory = {},
        achievements = {}
    },
    
    -- Inicialização
    init = function(self)
        -- Registra eventos base
        self:registrarEventosBase()
        
        -- Inicia sistemas
        self:iniciarSistemas()
        
        -- Carrega dados
        self:carregarDados()
    end,
    
    -- Registro de eventos base
    registrarEventosBase = function(self)
        -- Eventos de conexão
        addEventHandler("onPlayerJoin", root,
            function()
                self:onPlayerJoin(source)
            end
        )
        
        addEventHandler("onPlayerQuit", root,
            function(quitType)
                self:onPlayerQuit(source, quitType)
            end
        )
        
        -- Eventos de gameplay
        addEventHandler("onPlayerWasted", root,
            function(killer, weapon)
                self:onPlayerWasted(source, killer, weapon)
            end
        )
        
        addEventHandler("onPlayerCommand", root,
            function(command)
                self:onPlayerCommand(source, command)
            end
        )
    end,
    
    -- Handlers de eventos
    onPlayerJoin = function(self, player)
        -- Inicializa dados
        self.cache.playerStats[player] = {
            joinTime = getTickCount(),
            kills = 0,
            deaths = 0,
            commands = {}
        }
        
        -- Carrega dados salvos
        self:carregarDadosJogador(player)
        
        -- Verifica conquistas
        self:verificarConquistas(player, "login")
    end,
    
    onPlayerQuit = function(self, player, quitType)
        -- Salva stats
        if self.config.saveStats then
            self:salvarDadosJogador(player)
        end
        
        -- Limpa cache
        self.cache.playerStats[player] = nil
    end,
    
    onPlayerWasted = function(self, player, killer, weapon)
        -- Atualiza stats
        if killer then
            self:atualizarStat(killer, "kills", 1)
        end
        self:atualizarStat(player, "deaths", 1)
        
        -- Verifica conquistas
        if killer then
            self:verificarConquistas(killer, "kill")
        end
        
        -- Log
        if self.config.logEvents then
            self:logEvento("morte", {
                vitima = getPlayerName(player),
                assassino = killer and getPlayerName(killer) or "Ninguém",
                arma = weapon
            })
        end
    end,
    
    onPlayerCommand = function(self, player, command)
        -- Registra comando
        local stats = self.cache.playerStats[player]
        if stats then
            stats.commands[command] = (stats.commands[command] or 0) + 1
        end
        
        -- Verifica conquistas
        self:verificarConquistas(player, "command")
    end,
    
    -- Sistema de Stats
    atualizarStat = function(self, player, stat, valor)
        local stats = self.cache.playerStats[player]
        if stats then
            stats[stat] = (stats[stat] or 0) + valor
            
            -- Broadcast
            if self.config.broadcastEvents then
                triggerClientEvent("onStatUpdate", player, stat, stats[stat])
            end
        end
    end,
    
    -- Sistema de Conquistas
    verificarConquistas = function(self, player, tipo)
        local stats = self.cache.playerStats[player]
        if not stats then return end
        
        -- Conquistas por tipo
        if tipo == "login" then
            self:darConquista(player, "Primeiro Login")
        elseif tipo == "kill" and stats.kills >= 100 then
            self:darConquista(player, "100 Kills")
        elseif tipo == "command" then
            local totalComandos = 0
            for _, count in pairs(stats.commands) do
                totalComandos = totalComandos + count
            end
            if totalComandos >= 1000 then
                self:darConquista(player, "Veterano")
            end
        end
    end,
    
    darConquista = function(self, player, conquista)
        if not self.cache.achievements[player] then
            self.cache.achievements[player] = {}
        end
        
        if not self.cache.achievements[player][conquista] then
            self.cache.achievements[player][conquista] = true
            
            -- Dispara evento
            triggerEvent("onPlayerAchievement", player, conquista)
            
            -- Log
            if self.config.logEvents then
                self:logEvento("conquista", {
                    jogador = getPlayerName(player),
                    conquista = conquista
                })
            end
        end
    end,
    
    -- Sistema de Log
    logEvento = function(self, tipo, dados)
        local tempo = os.date("%Y-%m-%d %H:%M:%S")
        local log = string.format("[%s] %s: %s",
            tempo,
            tipo,
            table.tostring(dados)
        )
        
        table.insert(self.cache.eventHistory, log)
        outputDebugString(log)
    end,
    
    -- Salvamento de dados
    salvarDadosJogador = function(self, player)
        local stats = self.cache.playerStats[player]
        if not stats then return end
        
        -- Prepara dados
        local dados = {
            stats = stats,
            achievements = self.cache.achievements[player] or {}
        }
        
        -- Salva em XML
        local account = getPlayerAccount(player)
        if account then
            setAccountData(account, "playerStats", toJSON(dados))
        end
    end,
    
    carregarDadosJogador = function(self, player)
        local account = getPlayerAccount(player)
        if account then
            local dados = fromJSON(getAccountData(account, "playerStats") or "[]")
            
            -- Carrega stats
            if dados.stats then
                self.cache.playerStats[player] = dados.stats
            end
            
            -- Carrega conquistas
            if dados.achievements then
                self.cache.achievements[player] = dados.achievements
            end
        end
    end
}

-- Inicialização
addEventHandler("onResourceStart", resourceRoot,
    function()
        PlayerEventSystem:init()
    end
)

## Exemplos Práticos

### 1. Sistema de Conquistas
```lua
local Conquistas = {
    lista = {
        ["Primeiro Login"] = {
            descricao = "Faça seu primeiro login",
            recompensa = 1000
        },
        ["100 Kills"] = {
            descricao = "Mate 100 jogadores",
            recompensa = 5000
        },
        ["Veterano"] = {
            descricao = "Use 1000 comandos",
            recompensa = 10000
        }
    },
    
    darConquista = function(self, player, conquista)
        if not self.lista[conquista] then return end
        
        -- Verifica se já tem
        local achievements = getElementData(player, "achievements") or {}
        if achievements[conquista] then return end
        
        -- Dá conquista
        achievements[conquista] = true
        setElementData(player, "achievements", achievements)
        
        -- Recompensa
        givePlayerMoney(player, self.lista[conquista].recompensa)
        
        -- Notifica
        outputChatBox(string.format("Conquista desbloqueada: %s", conquista), player, 255, 255, 0)
        outputChatBox(string.format("Recompensa: $%d", self.lista[conquista].recompensa), player, 255, 255, 0)
    end
}
```

### 2. Sistema de Eventos PvP
```lua
local PvPEvents = {
    eventos = {},
    
    criarEvento = function(self, tipo, config)
        local evento = {
            tipo = tipo,
            jogadores = {},
            estado = "aguardando",
            config = config,
            inicio = 0
        }
        
        -- Adiciona handlers
        self:adicionarHandlers(evento)
        
        table.insert(self.eventos, evento)
        return #self.eventos
    end,
    
    adicionarHandlers = function(self, evento)
        -- Morte
        addEventHandler("onPlayerWasted", root,
            function(killer)
                if evento.estado == "rodando" then
                    self:processarMorte(evento, source, killer)
                end
            end
        )
        
        -- Quit
        addEventHandler("onPlayerQuit", root,
            function()
                if evento.jogadores[source] then
                    self:removerJogador(evento, source)
                end
            end
        )
    end,
    
    processarMorte = function(self, evento, morto, assassino)
        if evento.jogadores[morto] then
            evento.jogadores[morto].mortes = evento.jogadores[morto].mortes + 1
            
            if assassino and evento.jogadores[assassino] then
                evento.jogadores[assassino].kills = evento.jogadores[assassino].kills + 1
            end
            
            -- Verifica fim
            self:verificarFim(evento)
        end
    end,
    
    verificarFim = function(self, evento)
        -- Por tempo
        if getTickCount() - evento.inicio >= evento.config.duracao then
            self:finalizarEvento(evento)
            return
        end
        
        -- Por kills
        for player, dados in pairs(evento.jogadores) do
            if dados.kills >= evento.config.killsParaVencer then
                self:finalizarEvento(evento, player)
                return
            end
        end
    end
}
```

### 3. Sistema de Eventos Temporários
```lua
local EventoTemporario = {
    eventos = {},
    
    criar = function(self, nome, config)
        local evento = {
            nome = nome,
            inicio = getTickCount(),
            duracao = config.duracao,
            participantes = {},
            config = config
        }
        
        -- Timer de fim
        setTimer(function()
            self:finalizar(evento)
        end, config.duracao, 1)
        
        -- Anuncia
        outputChatBox("Evento iniciado: " .. nome)
        
        table.insert(self.eventos, evento)
        return evento
    end,
    
    participar = function(self, evento, player)
        if not evento.participantes[player] then
            evento.participantes[player] = {
                pontos = 0,
                inicio = getTickCount()
            }
            
            -- Aplica efeitos
            if evento.config.onJoin then
                evento.config.onJoin(player)
            end
        end
    end,
    
    finalizar = function(self, evento)
        -- Recompensas
        for player, dados in pairs(evento.participantes) do
            if isElement(player) then
                local recompensa = dados.pontos * evento.config.multiplicador
                givePlayerMoney(player, recompensa)
                outputChatBox("Você ganhou $" .. recompensa, player)
            end
        end
        
        -- Limpa
        for i, e in ipairs(self.eventos) do
            if e == evento then
                table.remove(self.eventos, i)
                break
            end
        end
        
        outputChatBox("Evento finalizado: " .. evento.nome)
    end
}
```

## Dicas e Boas Práticas

1. **Segurança**
```lua
-- Verifique fonte do evento
addEventHandler("onCustomEvent", root,
    function()
        if client ~= source then
            return  -- Evita spoofing
        end
    end
)

-- Valide dados
function validarDados(dados)
    if type(dados) ~= "table" then return false end
    if not dados.valor or type(dados.valor) ~= "number" then return false end
    return true
end
```

2. **Debug**
```lua
function logEvento(tipo, dados)
    if not settings.debug then return end
    
    outputDebugString(string.format("[%s] %s: %s",
        os.date("%H:%M:%S"),
        tipo,
        inspect(dados)
    ))
end
```

3. **Documentação**
```lua
--[[
    Evento: onPlayerAchievement
    Descrição: Disparado quando jogador ganha conquista
    Parâmetros:
        - achievement: string (nome da conquista)
        - recompensa: number (valor da recompensa)
    Exemplo:
        addEventHandler("onPlayerAchievement", root,
            function(achievement, recompensa)
                outputChatBox("Conquista: " .. achievement)
            end
        )
]]
