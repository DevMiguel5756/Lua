# Variáveis Especiais no MTA:SA

## Variáveis Globais

### root
```lua
-- Representa o elemento raiz do servidor
addEventHandler("onPlayerJoin", root,
    function()
        outputChatBox("Bem vindo!", source)
    end
)
```

### resourceRoot
```lua
-- Representa o elemento raiz do recurso
addEventHandler("onResourceStart", resourceRoot,
    function()
        outputDebugString("Recurso iniciado!")
    end
)
```

### source
```lua
-- Representa o elemento que disparou o evento
addEventHandler("onPlayerWasted", root,
    function(ammo, killer, weapon)
        local nome = getPlayerName(source)
        outputChatBox(nome .. " morreu!")
    end
)
```

### client
```lua
-- Representa o cliente que disparou um evento (servidor)
addEvent("onClientRequest", true)
addEventHandler("onClientRequest", root,
    function()
        if client ~= source then return end
        -- Processa requisição
    end
)
```

### localPlayer
```lua
-- Representa o jogador local (cliente)
addEventHandler("onClientRender", root,
    function()
        local x, y, z = getElementPosition(localPlayer)
        dxDrawText("Posição: " .. x .. "," .. y .. "," .. z,
            10, 10)
    end
)
```

## Variáveis de Ambiente

### getThisResource()
```lua
-- Obtém o recurso atual
local function getResourceName()
    local resource = getThisResource()
    return getResourceName(resource)
end
```

### getResourceConfig()
```lua
-- Obtém configuração do recurso
local config = getResourceConfig("config.xml")
if config then
    local settings = xmlLoadFile(config)
    -- Processa configurações
end
```

### getResourceDynamicElementRoot()
```lua
-- Obtém raiz de elementos dinâmicos
local elementRoot = getResourceDynamicElementRoot(getThisResource())
```

## Variáveis de Estado

### Servidor vs Cliente
```lua
-- Verifica lado
if isServer() then
    outputDebugString("Código servidor")
else
    outputDebugString("Código cliente")
end
```

### Debug Mode
```lua
-- Verifica modo debug
if getResourceInfo(getThisResource(), "debug") == "true" then
    outputDebugString("Debug ativado")
end
```

## Sistemas Práticos

### 1. Sistema de Configuração
```lua
local ConfigSystem = {
    config = {},
    
    load = function(self)
        local resource = getThisResource()
        local configFile = getResourceConfig("config.xml")
        
        if not configFile then
            outputDebugString("Arquivo config.xml não encontrado!")
            return false
        end
        
        local xml = xmlLoadFile(configFile)
        if not xml then
            outputDebugString("Erro ao carregar config.xml!")
            return false
        end
        
        -- Carrega configurações
        local settings = xmlNodeGetChildren(xml)
        for _, node in ipairs(settings) do
            local name = xmlNodeGetName(node)
            local value = xmlNodeGetValue(node)
            self.config[name] = value
        end
        
        xmlUnloadFile(xml)
        return true
    end,
    
    get = function(self, key, default)
        return self.config[key] or default
    end,
    
    set = function(self, key, value)
        self.config[key] = value
        
        -- Salva em tempo real
        local xml = xmlCreateFile("config.xml", "config")
        for k, v in pairs(self.config) do
            local node = xmlCreateChild(xml, k)
            xmlNodeSetValue(node, tostring(v))
        end
        xmlSaveFile(xml)
        xmlUnloadFile(xml)
    end
}
```

### 2. Sistema de Debug
```lua
local DebugSystem = {
    enabled = false,
    levels = {
        info = true,
        warn = true,
        error = true
    },
    
    init = function(self)
        self.enabled = getResourceInfo(getThisResource(), "debug") == "true"
        
        -- Registra comando debug
        if isServer() then
            addCommandHandler("debug",
                function(player)
                    if hasObjectPermissionTo(player, "resource.debug") then
                        self.enabled = not self.enabled
                        outputChatBox("Debug " .. 
                            (self.enabled and "ativado" or "desativado"),
                            player)
                    end
                end
            )
        end
    end,
    
    log = function(self, level, message, ...)
        if not self.enabled or not self.levels[level] then return end
        
        local formatted = string.format(message, ...)
        local prefix = string.upper(level)
        local resource = getResourceName(getThisResource())
        
        outputDebugString(string.format("[%s][%s] %s",
            resource,
            prefix,
            formatted
        ))
    end,
    
    info = function(self, message, ...)
        self:log("info", message, ...)
    end,
    
    warn = function(self, message, ...)
        self:log("warn", message, ...)
    end,
    
    error = function(self, message, ...)
        self:log("error", message, ...)
    end
}
```

### 3. Sistema de Recursos
```lua
local ResourceManager = {
    dependencies = {},
    
    init = function(self)
        -- Carrega dependências
        local meta = xmlLoadFile("meta.xml")
        if not meta then return end
        
        local deps = xmlNodeGetChildren(meta)
        for _, node in ipairs(deps) do
            if xmlNodeGetName(node) == "depend" then
                local resource = xmlNodeGetAttribute(node, "resource")
                table.insert(self.dependencies, resource)
            end
        end
        
        xmlUnloadFile(meta)
        
        -- Verifica dependências
        for _, dep in ipairs(self.dependencies) do
            if not getResourceFromName(dep) then
                outputDebugString("Dependência faltando: " .. dep)
                cancelEvent()
                return
            end
        end
    end,
    
    getPath = function(self, path)
        local resource = getThisResource()
        return ":" .. getResourceName(resource) .. "/" .. path
    end,
    
    getData = function(self, key, default)
        local resource = getThisResource()
        return getResourceInfo(resource, key) or default
    end,
    
    setData = function(self, key, value)
        local resource = getThisResource()
        setResourceInfo(resource, key, value)
    end
}
```

## Exemplos de Uso

### 1. Sistema de Logs
```lua
local LogSystem = {
    init = function(self)
        self.resource = getResourceName(getThisResource())
        self.debug = getResourceInfo(getThisResource(), "debug") == "true"
    end,
    
    log = function(self, message, ...)
        if not self.debug then return end
        
        local formatted = string.format(message, ...)
        outputDebugString(string.format("[%s] %s",
            self.resource,
            formatted
        ))
    end
}

-- Uso
LogSystem:init()
LogSystem:log("Jogador %s conectou", getPlayerName(source))
```

### 2. Sistema de Elementos
```lua
local ElementSystem = {
    init = function(self)
        self.root = getResourceDynamicElementRoot(getThisResource())
    end,
    
    create = function(self, tipo, x, y, z)
        local elemento = createElement(tipo)
        setElementPosition(elemento, x, y, z)
        setElementParent(elemento, self.root)
        return elemento
    end,
    
    destroy = function(self)
        local elementos = getElementChildren(self.root)
        for _, elemento in ipairs(elementos) do
            destroyElement(elemento)
        end
    end
}

-- Uso
ElementSystem:init()
local objeto = ElementSystem:create("object", 0, 0, 0)
```

### 3. Sistema de Eventos
```lua
local EventSystem = {
    init = function(self)
        self.resource = getThisResource()
        self.handlers = {}
    end,
    
    register = function(self, name, handler)
        if not self.handlers[name] then
            self.handlers[name] = {}
            addEvent(name, true)
        end
        
        table.insert(self.handlers[name], handler)
        addEventHandler(name, root, handler)
    end,
    
    unregister = function(self, name, handler)
        if not self.handlers[name] then return end
        
        for i, h in ipairs(self.handlers[name]) do
            if h == handler then
                removeEventHandler(name, root, handler)
                table.remove(self.handlers[name], i)
                break
            end
        end
    end,
    
    clear = function(self)
        for name, handlers in pairs(self.handlers) do
            for _, handler in ipairs(handlers) do
                removeEventHandler(name, root, handler)
            end
        end
        self.handlers = {}
    end
}
```

## Dicas e Boas Práticas

### 1. Performance
```lua
-- Cache de variáveis globais
local root = root
local resourceRoot = resourceRoot
local getResourceName = getResourceName
local getThisResource = getThisResource
```

### 2. Segurança
```lua
-- Verifique fonte de eventos
addEvent("onClientRequest", true)
addEventHandler("onClientRequest", root,
    function()
        if client ~= source then
            return -- Bloqueia spoofing
        end
    end
)
```

### 3. Debug
```lua
-- Use debug condicional
local function debug(message)
    if getResourceInfo(getThisResource(), "debug") == "true" then
        outputDebugString(message)
    end
end
```

## Exercícios

1. Crie um sistema que:
   - Gerencia configurações do recurso
   - Salva/carrega de XML
   - Permite modificação em runtime

2. Implemente um sistema que:
   - Rastreia elementos do recurso
   - Gerencia ciclo de vida
   - Limpa recursos não utilizados

3. Desenvolva um sistema que:
   - Gerencia eventos do recurso
   - Implementa handlers seguros
   - Permite debug fácil

## Conclusão

- Variáveis especiais são fundamentais
- Use-as corretamente para:
  - Segurança
  - Performance
  - Organização
  - Debug eficiente
