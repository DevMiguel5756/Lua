# Vamo Aprender Scripts no MTA:SA - Parte 1: O Básico

## 1. Como Montar seus Scripts

### 1.1 Scripts no Cliente vs Servidor
```lua
-- server.lua
addEventHandler("onResourceStart", resourceRoot,
    function()
        outputChatBox("Servidor tá no ar!")
    end
)

-- client.lua
addEventHandler("onClientResourceStart", resourceRoot,
    function()
        outputChatBox("Cliente tá rodando!")
    end
)
```

### 1.2 Como Configurar o Meta.xml
```xml
<meta>
    <info author="Seu Nome" version="1.0.0" type="script" />
    
    <!-- Scripts pro Servidor -->
    <script src="server.lua" type="server" />
    
    <!-- Scripts pro Cliente -->
    <script src="client.lua" type="client" />
    
    <!-- Seus Arquivos -->
    <file src="imagens/logo.png" />
    
    <!-- Funções q outros recursos podem usar -->
    <export function="minhaFuncao" type="server" />
    
    <!-- O q seu mod precisa pra funcionar -->
    <include resource="outro_recurso" />
    
    <!-- Configs do seu mod -->
    <settings>
        <setting name="configuracao" value="valor" />
    </settings>
</meta>
```

## 2. Eventos e Como Lidar com Eles

### 2.1 Eventos Básicos
```lua
-- Criar evento
addEvent("meuEvento", true)  -- true pra permitir client->server

-- Adicionar handler
addEventHandler("meuEvento", root,
    function(parametro)
        outputChatBox("Evento recebido: " .. tostring(parametro))
    end
)

-- Disparar evento
triggerEvent("meuEvento", source, "teste")

-- Disparar evento client->server
triggerServerEvent("meuEvento", resourceRoot, "teste")

-- Disparar evento server->client
triggerClientEvent(player, "meuEvento", resourceRoot, "teste")
```

### 2.2 Eventos Comuns
```lua
-- Jogador entrou
addEventHandler("onPlayerJoin", root,
    function()
        outputChatBox("Bem vindo, " .. getPlayerName(source))
    end
)

-- Jogador morreu
addEventHandler("onPlayerWasted", root,
    function(killer)
        if killer then
            outputChatBox(getPlayerName(killer) .. " matou " ..
                getPlayerName(source))
        end
    end
)

-- Veículo entrou
addEventHandler("onVehicleEnter", root,
    function(player, seat)
        if seat == 0 then  -- Motorista
            outputChatBox("Você está dirigindo!")
        end
    end
)

-- Colisão
addEventHandler("onClientColShapeHit", root,
    function(element, matching)
        if element == localPlayer and matching then
            outputChatBox("Você entrou na área!")
        end
    end
)
```

## 3. Elementos e Como Manipulá-los

### 3.1 Criar Elementos
```lua
-- Criar veículo
local function criarVeiculo(modelo, x, y, z)
    local veiculo = createVehicle(modelo, x, y, z)
    setElementFrozen(veiculo, true)
    return veiculo
end

-- Criar objeto
local function criarObjeto(modelo, x, y, z)
    local objeto = createObject(modelo, x, y, z)
    setElementCollisionsEnabled(objeto, true)
    return objeto
end

-- Criar marker
local function criarMarker(tipo, x, y, z, r, g, b, a)
    local marker = createMarker(x, y, z, tipo, 2,
        r or 255, g or 0, b or 0, a or 100)
    return marker
end

-- Criar blip
local function criarBlip(x, y, z, tipo, cor)
    local blip = createBlip(x, y, z, tipo or 0, 2,
        cor or 255, 0, 0, 255, 0, 99999)
    return blip
end

-- Criar colshape
local function criarArea(tipo, x, y, z, ...)
    local area
    if tipo == "circulo" then
        area = createColCircle(x, y, ...)
    elseif tipo == "esfera" then
        area = createColSphere(x, y, z, ...)
    elseif tipo == "retangulo" then
        area = createColRectangle(x, y, ...)
    elseif tipo == "cubo" then
        area = createColCuboid(x, y, z, ...)
    end
    return area
end
```

### 3.2 Manipular Elementos
```lua
-- Posição e rotação
local function setPosicao(elemento, x, y, z, rx, ry, rz)
    setElementPosition(elemento, x, y, z)
    if rx then
        setElementRotation(elemento, rx, ry, rz)
    end
end

-- Dimensão e interior
local function setDimensao(elemento, dimensao, interior)
    setElementDimension(elemento, dimensao or 0)
    setElementInterior(elemento, interior or 0)
end

-- Alpha e visibilidade
local function setVisibilidade(elemento, alpha, fade)
    if fade then
        setElementAlpha(elemento, alpha, true)
    else
        setElementAlpha(elemento, alpha)
    end
end

-- Dados do elemento
local function setDados(elemento, dados)
    for chave, valor in pairs(dados) do
        setElementData(elemento, chave, valor)
    end
end

-- Anexar elementos
local function anexarElemento(elemento, pai, x, y, z, rx, ry, rz)
    attachElements(elemento, pai, x or 0, y or 0, z or 0,
        rx or 0, ry or 0, rz or 0)
end
```

## 4. Comandos e ACL

### 4.1 Comandos Básicos
```lua
-- Comando simples
addCommandHandler("comando",
    function(player, cmd, ...)
        local args = {...}
        outputChatBox("Comando executado por " .. getPlayerName(player))
    end
)

-- Comando com permissão
addCommandHandler("admin",
    function(player, cmd)
        if hasObjectPermissionTo(player, "command.admin") then
            outputChatBox("Você é admin!")
        else
            outputChatBox("Sem permissão!")
        end
    end
)

-- Comando com argumentos
addCommandHandler("tp",
    function(player, cmd, x, y, z)
        if not x or not y or not z then
            outputChatBox("Uso: /tp x y z")
            return
        end
        
        setElementPosition(player, tonumber(x),
            tonumber(y), tonumber(z))
    end
)

-- Comando com alvo
addCommandHandler("kill",
    function(player, cmd, alvo)
        if not alvo then
            outputChatBox("Uso: /kill jogador")
            return
        end
        
        local targetPlayer = getPlayerFromName(alvo)
        if not targetPlayer then
            outputChatBox("Jogador não encontrado!")
            return
        end
        
        killPed(targetPlayer)
    end
)
```

### 4.2 Sistema de ACL
```lua
-- Verificar permissão
local function temPermissao(player, acl)
    local account = getPlayerAccount(player)
    if not account then return false end
    
    local accName = getAccountName(account)
    return isObjectInACLGroup("user." .. accName, aclGetGroup(acl))
end

-- Adicionar à ACL
local function addNaAcl(player, acl)
    local account = getPlayerAccount(player)
    if not account then return false end
    
    local accName = getAccountName(account)
    local aclGroup = aclGetGroup(acl)
    
    if not aclGroup then
        aclGroup = aclCreateGroup(acl)
    end
    
    return aclGroupAddObject(aclGroup, "user." .. accName)
end

-- Remover da ACL
local function removerDaAcl(player, acl)
    local account = getPlayerAccount(player)
    if not account then return false end
    
    local accName = getAccountName(account)
    local aclGroup = aclGetGroup(acl)
    
    if not aclGroup then return false end
    
    return aclGroupRemoveObject(aclGroup, "user." .. accName)
end

-- Sistema de ranks
local ranks = {
    ["admin"] = {
        nivel = 4,
        cor = "#FF0000",
        tag = "[Admin]"
    },
    ["mod"] = {
        nivel = 3,
        cor = "#00FF00",
        tag = "[Mod]"
    },
    ["vip"] = {
        nivel = 2,
        cor = "#0000FF",
        tag = "[VIP]"
    },
    ["user"] = {
        nivel = 1,
        cor = "#FFFFFF",
        tag = ""
    }
}

local function getRank(player)
    for rank, info in pairs(ranks) do
        if temPermissao(player, rank) then
            return rank, info
        end
    end
    return "user", ranks["user"]
end
```

## 5. GUI Básica

### 5.1 Elementos Básicos
```lua
-- Janela
local function criarJanela(titulo, x, y, w, h)
    local window = guiCreateWindow(x, y, w, h, titulo, false)
    guiWindowSetSizable(window, false)
    return window
end

-- Botão
local function criarBotao(texto, x, y, w, h, pai)
    return guiCreateButton(x, y, w, h, texto, false, pai)
end

-- Label
local function criarLabel(texto, x, y, w, h, pai)
    return guiCreateLabel(x, y, w, h, texto, false, pai)
end

-- Edit
local function criarEdit(texto, x, y, w, h, pai)
    return guiCreateEdit(x, y, w, h, texto, false, pai)
end

-- Memo
local function criarMemo(texto, x, y, w, h, pai)
    return guiCreateMemo(x, y, w, h, texto, false, pai)
end

-- Checkbox
local function criarCheckbox(texto, x, y, w, h, estado, pai)
    return guiCreateCheckBox(x, y, w, h, texto,
        estado or false, false, pai)
end

-- Radio
local function criarRadio(texto, x, y, w, h, pai)
    return guiCreateRadioButton(x, y, w, h, texto, false, pai)
end

-- Combobox
local function criarCombobox(x, y, w, h, pai)
    return guiCreateComboBox(x, y, w, h, "", false, pai)
end

-- Gridlist
local function criarGrid(x, y, w, h, pai)
    return guiCreateGridList(x, y, w, h, false, pai)
end

-- Tab panel
local function criarTabPanel(x, y, w, h, pai)
    return guiCreateTabPanel(x, y, w, h, false, pai)
end
```

### 5.2 Exemplo de Interface
```lua
local function criarLogin()
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = 300, 200
    local x = (screenW - windowW) / 2
    local y = (screenH - windowH) / 2
    
    local window = criarJanela("Login", x, y, windowW, windowH)
    
    -- Labels
    criarLabel("Usuário:", 0.1, 0.2, 0.3, 0.1, window)
    criarLabel("Senha:", 0.1, 0.4, 0.3, 0.1, window)
    
    -- Edits
    local editUser = criarEdit("", 0.4, 0.2, 0.5, 0.1, window)
    local editPass = criarEdit("", 0.4, 0.4, 0.5, 0.1, window)
    guiEditSetMasked(editPass, true)
    
    -- Checkbox
    local checkLembrar = criarCheckbox("Lembrar senha",
        0.1, 0.6, 0.5, 0.1, false, window)
    
    -- Botões
    local btnLogin = criarBotao("Entrar",
        0.2, 0.8, 0.25, 0.1, window)
    local btnCancel = criarBotao("Cancelar",
        0.55, 0.8, 0.25, 0.1, window)
    
    -- Handlers
    addEventHandler("onClientGUIClick", btnLogin,
        function()
            local user = guiGetText(editUser)
            local pass = guiGetText(editPass)
            local lembrar = guiCheckBoxGetSelected(checkLembrar)
            
            triggerServerEvent("onPlayerLogin", localPlayer,
                user, pass, lembrar)
        end
    )
    
    addEventHandler("onClientGUIClick", btnCancel,
        function()
            destroyElement(window)
            showCursor(false)
        end
    )
    
    -- Mostra cursor
    showCursor(true)
    
    return window
end
```

## 6. Dicas e Boas Práticas

### 6.1 Organização de Código
```lua
-- Usar namespaces
local MinhaClasse = {
    variaveis = {},
    
    init = function(self)
        -- Inicialização
    end,
    
    metodo = function(self, param)
        -- Método
    end
}

-- Separar em módulos
local utils = loadstring(exports.utils:getUtils())()

-- Usar constantes
local CONFIG = {
    MAX_PLAYERS = 32,
    SPAWN_POINTS = {
        {x = 0, y = 0, z = 3},
        {x = 10, y = 10, z = 3}
    }
}
```

### 6.2 Otimização
```lua
-- Cache de funções
local getTickCount = getTickCount
local sin = math.sin
local cos = math.cos

-- Cache de elementos
local localPlayer = getLocalPlayer()
local rootElement = getRootElement()

-- Evitar loops desnecessários
local function processarJogadores()
    local jogadores = {}
    for _, player in ipairs(getElementsByType("player")) do
        table.insert(jogadores, player)
    end
    return jogadores
end

-- Usar timers com cuidado
local function atualizarPosicao()
    local x, y, z = getElementPosition(localPlayer)
    -- Atualiza a cada 100ms
    setTimer(atualizarPosicao, 100, 1)
end
```

### 6.3 Debug
```lua
-- Debug básico
local function debug(msg)
    outputDebugString("[Debug] " .. tostring(msg))
end

-- Debug com nível
local function debugf(nivel, msg)
    outputDebugString("[" .. nivel .. "] " .. tostring(msg))
end

-- Debug com timestamp
local function debugt(msg)
    local time = os.date("%H:%M:%S")
    outputDebugString("[" .. time .. "] " .. tostring(msg))
end

-- Debug com cor
local function debugc(msg, r, g, b)
    outputChatBox(msg, root, r or 255, g or 255, b or 255)
end
```

## 7. Exercícios Práticos

1. Crie um sistema de spawn personalizado
2. Implemente um sistema de checkpoints
3. Desenvolva um sistema de mensagens privadas
4. Crie um painel de administração
5. Implemente um sistema de salvamento

## 8. Recursos Úteis

1. Wiki MTA:SA: https://wiki.multitheftauto.com/
2. Fórum MTA:SA: https://forum.mtasa.com/
3. Documentação Lua: https://www.lua.org/manual/5.1/
4. GitHub com exemplos: https://github.com/multitheftauto/

## 9. Próximos Passos

Continue para a Parte 2 do guia, onde abordaremos:
1. Sistemas complexos
2. Networking avançado
3. Otimização de performance
4. Técnicas de debugging
5. Integração com banco de dados
