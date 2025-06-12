# Vamo Aprender Scripts no MTA:SA - Parte 2: Avançado

## 1. Networking Avançado

### 1.1 Bandwidth Management
```lua
-- Configurar largura de banda
setNetworkUsageEnabled(true)
local stats = getNetworkStats()

-- Otimizar updates
local function syncElement(element, dataTable)
    if not isElement(element) then return end
    
    -- Calcula distância do player
    local x, y, z = getElementPosition(element)
    local players = getElementsByType("player")
    
    for _, player in ipairs(players) do
        local px, py, pz = getElementPosition(player)
        local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
        
        -- Só sync se estiver próximo
        if distance < 200 then
            triggerClientEvent(player, "onElementSync", element, dataTable)
        end
    end
end

-- Compressão de dados
local function compressData(data)
    return compressString(toJSON(data))
end

local function decompressData(data)
    return fromJSON(decompressString(data))
end
```

### 1.2 Custom Packets
```lua
-- Definir packet handler
addEventHandler("onPlayerCustomPacket", root,
    function(packetName, packetData)
        if packetName == "myPacket" then
            local decodedData = decompressData(packetData)
            -- Processa dados
        end
    end
)

-- Enviar packet customizado
local function sendCustomPacket(player, name, data)
    local compressed = compressData(data)
    triggerLatentClientEvent(player, "onCustomPacket", 
        resourceRoot, name, compressed)
end
```

## 2. Sistemas de Banco de Dados

### 2.1 SQLite
```lua
-- Conexão
local db = dbConnect("sqlite", "database.db")

-- Criar tabela
dbExec(db, [[
    CREATE TABLE IF NOT EXISTS players (
        account TEXT PRIMARY KEY,
        money INTEGER,
        level INTEGER,
        lastLogin TEXT
    )
]])

-- Inserir dados
local function savePlayerData(player)
    local account = getPlayerAccount(player)
    if not account then return end
    
    local accName = getAccountName(account)
    local money = getPlayerMoney(player)
    local level = getElementData(player, "level") or 1
    
    dbExec(db, "INSERT OR REPLACE INTO players VALUES (?,?,?,?)",
        accName, money, level, os.date())
end

-- Carregar dados
local function loadPlayerData(player)
    local account = getPlayerAccount(player)
    if not account then return end
    
    local accName = getAccountName(account)
    local result = dbPoll(dbQuery(db, 
        "SELECT * FROM players WHERE account=?", accName), -1)
        
    if result and result[1] then
        setPlayerMoney(player, result[1].money)
        setElementData(player, "level", result[1].level)
    end
end
```

### 2.2 MySQL
```lua
-- Conexão
local db = dbConnect("mysql", 
    "dbname=mta;host=localhost;charset=utf8", "user", "pass")

-- Queries assíncronas
local function queryAsync(query, ...)
    local queryHandle = dbQuery(db, query, ...)
    
    local function callback(qh)
        local result = dbPoll(qh, 0)
        if result then
            return result
        end
        return false
    end
    
    return callback, queryHandle
end

-- Exemplo de uso
local callback, queryHandle = queryAsync(
    "SELECT * FROM players WHERE level > ?", 10)
    
setTimer(function()
    local result = callback(queryHandle)
    if result then
        for _, row in ipairs(result) do
            outputDebugString(row.name)
        end
    end
end, 1000, 1)
```

## 3. Shaders e Efeitos

### 3.1 Shaders Básicos
```lua
-- Shader de cor
local colorShader = [[
float4 main(float2 tex : TEXCOORD0) : COLOR0
{
    float4 color = tex2D(sampler0, tex);
    return color * float4(1.0, 0.0, 0.0, 1.0);
}
]]

-- Aplicar shader
local function aplicarShaderVermelho()
    local shader = dxCreateShader(colorShader)
    engineApplyShaderToWorldTexture(shader, "*")
end

-- Shader de brilho
local glowShader = [[
float4 main(float2 tex : TEXCOORD0) : COLOR0
{
    float4 color = tex2D(sampler0, tex);
    return color * 1.5;
}
]]

-- Aplicar em veículo
local function aplicarBrilhoVeiculo(veiculo)
    local shader = dxCreateShader(glowShader)
    engineApplyShaderToWorldTexture(shader, "*", veiculo)
end
```

### 3.2 Efeitos Avançados
```lua
-- Efeito de água
local waterShader = [[
float4 main(float2 tex : TEXCOORD0) : COLOR0
{
    float2 center = float2(0.5, 0.5);
    float dist = distance(tex, center);
    float2 uv = tex + sin(dist * 10 - gTime) * 0.01;
    return tex2D(sampler0, uv);
}
]]

-- Efeito de distorção
local distortShader = [[
float4 main(float2 tex : TEXCOORD0) : COLOR0
{
    float2 uv = tex;
    uv.x += sin(uv.y * 10 + gTime) * 0.01;
    return tex2D(sampler0, uv);
}
]]

-- Sistema de partículas
local function criarParticulas(x, y, z)
    local effect = createEffect("smoke", x, y, z)
    setEffectDensity(effect, 2)
    setEffectSpeed(effect, 1)
    return effect
end
```

## 4. Otimização de Performance

### 4.1 Client-side
```lua
-- Limitar updates
local lastUpdate = 0
local updateInterval = 50 -- ms

addEventHandler("onClientRender", root,
    function()
        local currentTime = getTickCount()
        if currentTime - lastUpdate < updateInterval then
            return
        end
        lastUpdate = currentTime
        
        -- Código de update aqui
    end
)

-- LOD distance
local function setLODDistance(distance)
    setFarClipDistance(distance)
    setFogDistance(distance * 0.8)
    setCloudsEnabled(distance > 1000)
end

-- Object streaming
local function setupObjectStreaming()
    local streamDistance = 300
    
    for _, object in ipairs(getElementsByType("object")) do
        setElementStreamable(object, true)
        setElementStreamDistance(object, streamDistance)
    end
end
```

### 4.2 Server-side
```lua
-- Pooling de objetos
local ObjectPool = {
    pool = {},
    
    init = function(self, modelo, quantidade)
        self.pool[modelo] = {}
        for i = 1, quantidade do
            local obj = createObject(modelo, 0, 0, 0)
            setElementAlpha(obj, 0)
            table.insert(self.pool[modelo], obj)
        end
    end,
    
    get = function(self, modelo)
        if #self.pool[modelo] > 0 then
            return table.remove(self.pool[modelo])
        end
        return createObject(modelo, 0, 0, 0)
    end,
    
    return = function(self, objeto)
        local modelo = getElementModel(objeto)
        setElementAlpha(objeto, 0)
        table.insert(self.pool[modelo], objeto)
    end
}

-- Cache de colisões
local CollisionCache = {
    cache = {},
    
    check = function(self, elem1, elem2)
        local id1 = getElementID(elem1)
        local id2 = getElementID(elem2)
        local key = id1 .. "-" .. id2
        
        if self.cache[key] then
            return self.cache[key]
        end
        
        local result = isElementCollidableWith(elem1, elem2)
        self.cache[key] = result
        return result
    end,
    
    clear = function(self)
        self.cache = {}
    end
}
```

## 5. Debug e Profiling

### 5.1 Debug Tools
```lua
-- Debug viewer
local DebugView = {
    enabled = false,
    lines = {},
    
    add = function(self, text)
        table.insert(self.lines, tostring(text))
        if #self.lines > 20 then
            table.remove(self.lines, 1)
        end
    end,
    
    render = function(self)
        if not self.enabled then return end
        
        local y = 0.1
        for _, line in ipairs(self.lines) do
            dxDrawText(line, 0.1, y, 1, y + 0.05,
                tocolor(255, 255, 255, 255), 1.5, "default", "left", "top", 
                false, false, true)
            y = y + 0.05
        end
    end,
    
    toggle = function(self)
        self.enabled = not self.enabled
    end
}

addEventHandler("onClientRender", root,
    function()
        DebugView:render()
    end
)

-- Performance monitor
local PerfMon = {
    timers = {},
    
    start = function(self, name)
        self.timers[name] = getTickCount()
    end,
    
    stop = function(self, name)
        if not self.timers[name] then return 0 end
        
        local elapsed = getTickCount() - self.timers[name]
        self.timers[name] = nil
        return elapsed
    end,
    
    measure = function(self, name, func, ...)
        self:start(name)
        local result = func(...)
        local time = self:stop(name)
        
        DebugView:add(name .. ": " .. time .. "ms")
        return result
    end
}
```

### 5.2 Error Handling
```lua
-- Error logger
local ErrorLog = {
    file = nil,
    
    init = function(self)
        self.file = fileCreate("errors.log")
    end,
    
    log = function(self, error)
        if not self.file then return end
        
        local time = os.date("%Y-%m-%d %H:%M:%S")
        local text = string.format("[%s] %s\n", time, error)
        
        fileWrite(self.file, text)
        fileFlush(self.file)
    end,
    
    close = function(self)
        if self.file then
            fileClose(self.file)
        end
    end
}

-- Try-catch simulation
local function try(f)
    local status, error = pcall(f)
    
    if not status then
        ErrorLog:log(error)
        return false, error
    end
    
    return true
end
```

## 6. Técnicas Avançadas

### 6.1 Pooling e Caching
```lua
-- Resource pooling
local ResourcePool = {
    pools = {},
    
    createPool = function(self, name, creator, initialSize)
        self.pools[name] = {
            active = {},
            inactive = {},
            creator = creator
        }
        
        -- Pre-allocate
        for i = 1, initialSize do
            local obj = creator()
            table.insert(self.pools[name].inactive, obj)
        end
    end,
    
    acquire = function(self, name)
        local pool = self.pools[name]
        if not pool then return nil end
        
        local obj
        if #pool.inactive > 0 then
            obj = table.remove(pool.inactive)
        else
            obj = pool.creator()
        end
        
        table.insert(pool.active, obj)
        return obj
    end,
    
    release = function(self, name, obj)
        local pool = self.pools[name]
        if not pool then return end
        
        for i, activeObj in ipairs(pool.active) do
            if activeObj == obj then
                table.remove(pool.active, i)
                table.insert(pool.inactive, obj)
                break
            end
        end
    end
}

-- Data caching
local DataCache = {
    cache = {},
    timeout = 5000,  -- 5 seconds
    
    get = function(self, key)
        local entry = self.cache[key]
        if not entry then return nil end
        
        if getTickCount() - entry.time > self.timeout then
            self.cache[key] = nil
            return nil
        end
        
        return entry.value
    end,
    
    set = function(self, key, value)
        self.cache[key] = {
            value = value,
            time = getTickCount()
        }
    end,
    
    clear = function(self)
        self.cache = {}
    end
}
```

### 6.2 Event Queuing
```lua
-- Event queue
local EventQueue = {
    queue = {},
    processing = false,
    
    add = function(self, event)
        table.insert(self.queue, event)
        if not self.processing then
            self:process()
        end
    end,
    
    process = function(self)
        self.processing = true
        
        while #self.queue > 0 do
            local event = table.remove(self.queue, 1)
            
            if event.delay then
                setTimer(function()
                    event.handler(unpack(event.args))
                end, event.delay, 1)
            else
                event.handler(unpack(event.args))
            end
        end
        
        self.processing = false
    end
}

-- Uso
EventQueue:add({
    handler = function(player, weapon)
        -- Código aqui
    end,
    args = {source, weapon},
    delay = 1000  -- Optional delay
})
```

## 7. Exercícios Avançados

1. Implemente um sistema de física customizado
2. Crie um sistema de IA para NPCs
3. Desenvolva um sistema de replicação de dados
4. Implemente um sistema de pathfinding
5. Crie um sistema de streaming customizado

## 8. Recursos Avançados

1. Performance Profilers
2. Memory Leak Detection
3. Network Analysis Tools
4. Shader Development Kit
5. Advanced Debugging Tools

## 9. Próximos Passos

Continue para a Parte 3 do guia, onde abordaremos:
1. Sistemas de IA
2. Física avançada
3. Networking em tempo real
4. Shaders complexos
5. Otimização extrema
