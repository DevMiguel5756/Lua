# Funções de Mundo no MTA:SA

## Níveis de Conhecimento

### 1. Iniciante
#### O que são funções de mundo?
São comandos que permitem manipular o ambiente do jogo, incluindo:
- Clima e tempo
- Objetos
- Markers
- Blips
- Colisões
- E muito mais!

#### Funções Básicas
```lua
-- Clima e Tempo
setTime(12, 0)                    -- Define hora (12:00)
setWeather(0)                     -- Clima ensolarado
setMinuteDuration(60000)          -- 1 minuto real = 1 minuto no jogo

-- Objetos
createObject(1337, x, y, z)       -- Cria objeto
setObjectScale(objeto, 2.0)       -- Define escala

-- Markers e Blips
createMarker(x, y, z, "cylinder") -- Cria marker cilíndrico
createBlip(x, y, z)              -- Cria blip no mapa
```

### 2. Intermediário
#### Sistema de Clima Dinâmico
```lua
local ClimaManager = {
    climas = {
        {id = 0, nome = "Ensolarado", duracao = 30},
        {id = 8, nome = "Nublado", duracao = 15},
        {id = 16, nome = "Chuvoso", duracao = 10},
        -- Adicione mais climas
    },
    
    atual = 1,
    
    iniciar = function(self)
        self:mudarClima()
        setTimer(function()
            self:mudarClima()
        end, 60000 * 30, 0)  -- Muda a cada 30 minutos
    end,
    
    mudarClima = function(self)
        local clima = self.climas[self.atual]
        setWeather(clima.id)
        
        -- Avança para próximo clima
        self.atual = self.atual + 1
        if self.atual > #self.climas then
            self.atual = 1
        end
    end
}
```

### 3. Avançado
#### Sistema de Áreas e Zonas
```lua
local ZoneManager = {
    zonas = {},
    
    criarZona = function(self, nome, tipo, x, y, z, raio)
        local zona = {
            nome = nome,
            tipo = tipo,
            posicao = {x = x, y = y, z = z},
            raio = raio,
            jogadores = {},
            marker = nil,
            colshape = nil,
            blip = nil
        }
        
        -- Cria elementos visuais
        zona.marker = createMarker(x, y, z, "cylinder", raio,
            255, 0, 0, 100)  -- Marker vermelho
            
        zona.colshape = createColCircle(x, y, raio)
        
        zona.blip = createBlip(x, y, z, 0, 2, 255, 0, 0, 255)
        
        -- Adiciona handlers
        addEventHandler("onColShapeHit", zona.colshape,
            function(element)
                if getElementType(element) == "player" then
                    self:jogadorEntrou(zona, element)
                end
            end
        )
        
        addEventHandler("onColShapeLeave", zona.colshape,
            function(element)
                if getElementType(element) == "player" then
                    self:jogadorSaiu(zona, element)
                end
            end
        )
        
        -- Salva zona
        table.insert(self.zonas, zona)
        return #self.zonas
    end,
    
    jogadorEntrou = function(self, zona, player)
        zona.jogadores[player] = true
        
        -- Aplica efeitos baseado no tipo
        if zona.tipo == "cura" then
            self:iniciarCura(player)
        elseif zona.tipo == "dano" then
            self:iniciarDano(player)
        elseif zona.tipo == "evento" then
            self:iniciarEvento(player)
        end
    end,
    
    jogadorSaiu = function(self, zona, player)
        zona.jogadores[player] = nil
        
        -- Remove efeitos
        if zona.tipo == "cura" then
            self:pararCura(player)
        elseif zona.tipo == "dano" then
            self:pararDano(player)
        end
    end,
    
    -- Efeitos de Zona
    iniciarCura = function(self, player)
        setElementData(player, "emZonaCura", true)
        setTimer(function()
            if isElement(player) and getElementData(player, "emZonaCura") then
                setElementHealth(player, getElementHealth(player) + 1)
            end
        end, 1000, 0)
    end,
    
    iniciarDano = function(self, player)
        setElementData(player, "emZonaDano", true)
        setTimer(function()
            if isElement(player) and getElementData(player, "emZonaDano") then
                setElementHealth(player, getElementHealth(player) - 1)
            end
        end, 1000, 0)
    end,
    
    iniciarEvento = function(self, player)
        triggerClientEvent(player, "iniciarEventoEspecial", player)
    end
}
```

### 4. Expert
#### Sistema Completo de Mundo Dinâmico
```lua
local WorldManager = {
    -- Configurações
    config = {
        tempoReal = false,
        climaDinamico = true,
        eventosAleatorios = true,
        maxJogadoresPorZona = 10
    },
    
    -- Sistemas
    sistemas = {
        clima = nil,
        tempo = nil,
        zonas = nil,
        eventos = nil
    },
    
    -- Inicialização
    init = function(self)
        -- Inicia sistemas
        self.sistemas.clima = ClimaManager:new()
        self.sistemas.tempo = TempoManager:new()
        self.sistemas.zonas = ZoneManager:new()
        self.sistemas.eventos = EventManager:new()
        
        -- Configura mundo
        self:configurarMundo()
        
        -- Inicia loops
        self:iniciarLoops()
    end,
    
    -- Configuração inicial
    configurarMundo = function(self)
        -- Configurações básicas
        setGameSpeed(1.0)
        setGravity(0.008)
        setWaveHeight(0)
        
        -- Tempo inicial
        if self.config.tempoReal then
            local hora = tonumber(os.date("%H"))
            local minuto = tonumber(os.date("%M"))
            setTime(hora, minuto)
        else
            setTime(12, 0)
        end
        
        -- Clima inicial
        if self.config.climaDinamico then
            self.sistemas.clima:iniciar()
        else
            setWeather(0)
        end
    end,
    
    -- Loops de atualização
    iniciarLoops = function(self)
        -- Atualização de tempo
        if self.config.tempoReal then
            setTimer(function()
                local hora = tonumber(os.date("%H"))
                local minuto = tonumber(os.date("%M"))
                setTime(hora, minuto)
            end, 60000, 0)  -- Atualiza a cada minuto
        end
        
        -- Eventos aleatórios
        if self.config.eventosAleatorios then
            setTimer(function()
                self:gerarEventoAleatorio()
            end, 1800000, 0)  -- A cada 30 minutos
        end
        
        -- Atualização de zonas
        setTimer(function()
            self:atualizarZonas()
        end, 1000, 0)
    end,
    
    -- Eventos Aleatórios
    gerarEventoAleatorio = function(self)
        local eventos = {
            self.gerarTempestade,
            self.gerarInvasaoZombies,
            self.gerarChuvaMeteoros,
            -- Adicione mais eventos
        }
        
        local evento = eventos[math.random(#eventos)]
        evento(self)
    end,
    
    gerarTempestade = function(self)
        setWeather(8)  -- Tempestade
        setWindVelocity(2, 2, 0)
        
        -- Efeitos
        for _, player in ipairs(getElementsByType("player")) do
            triggerClientEvent(player, "iniciarEfeitosTempestade", player)
        end
        
        -- Retorna ao normal após 5 minutos
        setTimer(function()
            self.sistemas.clima:mudarClima()
            setWindVelocity(0, 0, 0)
        end, 300000, 1)
    end,
    
    gerarInvasaoZombies = function(self)
        -- Implementar invasão de zombies
    end,
    
    gerarChuvaMeteoros = function(self)
        -- Implementar chuva de meteoros
    end,
    
    -- Gerenciamento de Zonas
    atualizarZonas = function(self)
        for _, zona in ipairs(self.sistemas.zonas.zonas) do
            -- Verifica limite de jogadores
            local numJogadores = 0
            for player in pairs(zona.jogadores) do
                if isElement(player) then
                    numJogadores = numJogadores + 1
                else
                    zona.jogadores[player] = nil
                end
            end
            
            -- Atualiza visual da zona
            if numJogadores >= self.config.maxJogadoresPorZona then
                setMarkerColor(zona.marker, 255, 0, 0, 100)  -- Vermelho = cheia
            else
                setMarkerColor(zona.marker, 0, 255, 0, 100)  -- Verde = disponível
            end
            
            -- Aplica efeitos da zona
            self:aplicarEfeitosZona(zona)
        end
    end,
    
    -- Efeitos de Zona
    aplicarEfeitosZona = function(self, zona)
        for player in pairs(zona.jogadores) do
            if isElement(player) then
                if zona.tipo == "radiacao" then
                    local health = getElementHealth(player)
                    setElementHealth(player, health - 1)
                elseif zona.tipo == "regeneracao" then
                    local health = getElementHealth(player)
                    setElementHealth(player, math.min(100, health + 1))
                end
            end
        end
    end
}

-- Sistema de Tempo
local TempoManager = {
    new = function(self)
        local instance = {}
        
        instance.multiplicador = 1
        instance.pausado = false
        
        function instance:setMultiplicador(valor)
            self.multiplicador = valor
            setMinuteDuration(60000 / valor)
        end
        
        function instance:pausar()
            self.pausado = true
            setMinuteDuration(999999999)
        end
        
        function instance:continuar()
            self.pausado = false
            self:setMultiplicador(self.multiplicador)
        end
        
        return instance
    end
}

-- Sistema de Eventos
local EventManager = {
    new = function(self)
        local instance = {}
        
        instance.eventos = {}
        instance.eventosAtivos = {}
        
        function instance:registrarEvento(nome, config)
            self.eventos[nome] = config
        end
        
        function instance:iniciarEvento(nome)
            if self.eventos[nome] and not self.eventosAtivos[nome] then
                local evento = self.eventos[nome]
                self.eventosAtivos[nome] = true
                
                -- Inicia evento
                if evento.onStart then
                    evento.onStart()
                end
                
                -- Agenda fim
                if evento.duracao then
                    setTimer(function()
                        self:finalizarEvento(nome)
                    end, evento.duracao * 1000, 1)
                end
            end
        end
        
        function instance:finalizarEvento(nome)
            if self.eventosAtivos[nome] then
                local evento = self.eventos[nome]
                self.eventosAtivos[nome] = false
                
                -- Finaliza evento
                if evento.onEnd then
                    evento.onEnd()
                end
            end
        end
        
        return instance
    end
}
```

## Exemplos Práticos

### 1. Sistema de Dia e Noite
```lua
local DiaNoite = {
    duracaoDia = 24,  -- minutos reais
    
    init = function(self)
        -- Inicia ciclo
        self:atualizarTempo()
        
        setTimer(function()
            self:atualizarTempo()
        end, 60000, 0)  -- Atualiza a cada minuto
    end,
    
    atualizarTempo = function(self)
        local tempo = getRealTime()
        local hora = tempo.hour
        local minuto = tempo.minute
        
        -- Define tempo no jogo
        setTime(hora, minuto)
        
        -- Ajusta ambiente
        if hora >= 6 and hora < 20 then
            -- Dia
            setSunSize(1)
            setSunColor(255, 255, 255, 255, 255, 255)
            setFarClipDistance(1000)
        else
            -- Noite
            setSunSize(0)
            setFarClipDistance(500)
        end
    end
}
```

### 2. Sistema de Eventos Climáticos
```lua
local EventosClimaticos = {
    eventos = {
        tempestade = {
            clima = 8,
            vento = {2, 2, 0},
            duracao = 300,  -- segundos
            raios = true
        },
        neblina = {
            clima = 9,
            vento = {0, 0, 0},
            duracao = 600,
            visibilidade = 100
        }
    },
    
    iniciarEvento = function(self, nome)
        local evento = self.eventos[nome]
        if not evento then return end
        
        -- Aplica configurações
        setWeather(evento.clima)
        setWindVelocity(unpack(evento.vento))
        
        if evento.visibilidade then
            setFarClipDistance(evento.visibilidade)
        end
        
        -- Efeitos especiais
        if evento.raios then
            self:gerarRaios()
        end
        
        -- Agenda fim
        setTimer(function()
            self:finalizarEvento(nome)
        end, evento.duracao * 1000, 1)
    end,
    
    gerarRaios = function(self)
        setTimer(function()
            local x = math.random(-3000, 3000)
            local y = math.random(-3000, 3000)
            local z = 200
            
            createExplosion(x, y, z, 10)
        end, 10000, 0)  -- Raio a cada 10 segundos
    end
}
```

### 3. Sistema de Áreas Especiais
```lua
local AreasEspeciais = {
    areas = {},
    
    criarArea = function(self, tipo, x, y, z, raio)
        local area = {
            tipo = tipo,
            marker = createMarker(x, y, z, "cylinder", raio),
            colshape = createColCircle(x, y, raio),
            jogadores = {}
        }
        
        -- Configura visual
        if tipo == "cura" then
            setMarkerColor(area.marker, 0, 255, 0, 100)  -- Verde
        elseif tipo == "dano" then
            setMarkerColor(area.marker, 255, 0, 0, 100)  -- Vermelho
        end
        
        -- Adiciona handlers
        addEventHandler("onColShapeHit", area.colshape,
            function(element)
                if getElementType(element) == "player" then
                    self:jogadorEntrou(area, element)
                end
            end
        )
        
        table.insert(self.areas, area)
    end,
    
    jogadorEntrou = function(self, area, player)
        area.jogadores[player] = true
        
        if area.tipo == "cura" then
            setTimer(function()
                if isElement(player) and area.jogadores[player] then
                    local health = getElementHealth(player)
                    setElementHealth(player, math.min(100, health + 1))
                end
            end, 1000, 0)
        end
    end
}
```

## Dicas e Boas Práticas

1. **Otimização de Colisões**
```lua
-- Use colshapes apropriados
local colCircle = createColCircle(x, y, raio)  -- Para áreas circulares
local colCuboid = createColCuboid(x, y, z, w, d, h)  -- Para áreas retangulares

-- Verifique colisões eficientemente
function isElementInArea(element, x, y, raio)
    local ex, ey = getElementPosition(element)
    return getDistanceBetweenPoints2D(x, y, ex, ey) <= raio
end
```

2. **Gerenciamento de Recursos**
```lua
-- Limpe elementos ao destruir áreas
function destruirArea(area)
    if isElement(area.marker) then destroyElement(area.marker) end
    if isElement(area.colshape) then destroyElement(area.colshape) end
    if isElement(area.blip) then destroyElement(area.blip) end
end

-- Remova timers não utilizados
local timers = {}
function criarTimer(func, intervalo)
    local timer = setTimer(func, intervalo, 0)
    table.insert(timers, timer)
    return timer
end

function limparTimers()
    for _, timer in ipairs(timers) do
        if isTimer(timer) then
            killTimer(timer)
        end
    end
    timers = {}
end
```

3. **Sincronização Cliente-Servidor**
```lua
-- Sincronize efeitos visuais
function sincronizarEfeitos(tipo, x, y, z)
    triggerClientEvent("aplicarEfeitosVisuais", root, tipo, x, y, z)
end

-- Verifique permissões
function verificarPermissao(player, acao)
    local account = getPlayerAccount(player)
    return hasObjectPermissionTo(account, acao)
end
```

4. **Debug e Logging**
```lua
function logMundoEvento(tipo, dados)
    local tempo = os.date("%Y-%m-%d %H:%M:%S")
    outputDebugString(string.format("[Mundo] %s - Tipo: %s, Dados: %s",
        tempo, tipo, tostring(dados)))
end
```
