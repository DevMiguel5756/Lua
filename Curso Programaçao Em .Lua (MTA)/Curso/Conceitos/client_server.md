# Client e Server no MTA:SA

Fala dev! Bora entender como funciona o client e server no MTA:SA? É mais fácil q parece!

## 1. Diferenças Básicas

### 1.1 Client Side
- Roda no PC do player
- Controla interface
- Processa inputs
- Mostra efeitos visuais
- Cuida da parte gráfica

### 1.2 Server Side
- Roda no servidor
- Guarda dados importantes
- Controla regras do jogo
- Sincroniza players
- Cuida da segurança

## 2. Quando Usar Cada Um

### 2.1 Usa Client Pra
1. **Interface**
   - Menus
   - HUD
   - Notificações
   - Telas custom

2. **Efeitos**
   - Partículas
   - Sons
   - Animações
   - Shaders

3. **Input**
   - Teclas
   - Mouse
   - Controles
   - Comandos

### 2.2 Usa Server Pra
1. **Dados**
   - Save/load
   - Database
   - Stats
   - Inventário

2. **Regras**
   - Anticheat
   - Permissões
   - Economia
   - Sistemas

3. **Sync**
   - Posições
   - Estados
   - Eventos
   - Updates

## 3. Comunicação

### 3.1 Client -> Server
```lua
-- No client
addEventHandler("onClientKey", root, function(key)
    if key == "x" then
        triggerServerEvent("onPlayerWantItem", localPlayer)
    end
end)

-- No server
addEvent("onPlayerWantItem", true)
addEventHandler("onPlayerWantItem", root, function()
    local player = source
    givePlayerItem(player, "item_legal")
end)
```

### 3.2 Server -> Client
```lua
-- No server
function notifyPlayer(player, msg)
    triggerClientEvent(player, "onNotification", player, msg)
end

-- No client
addEvent("onNotification", true)
addEventHandler("onNotification", localPlayer, function(msg)
    showNotification(msg)
end)
```

## 4. Exemplos Práticos

### 4.1 Sistema de Login
```lua
-- Client (login_c.lua)
local loginWindow = nil

function showLogin()
    loginWindow = guiCreateWindow(0.4, 0.4, 0.2, 0.2, "Login", true)
    local userEdit = guiCreateEdit(0.1, 0.2, 0.8, 0.1, "", true, loginWindow)
    local passEdit = guiCreateEdit(0.1, 0.4, 0.8, 0.1, "", true, loginWindow)
    local btnLogin = guiCreateButton(0.3, 0.6, 0.4, 0.2, "Entrar", true, loginWindow)
    
    addEventHandler("onClientGUIClick", btnLogin, function()
        local user = guiGetText(userEdit)
        local pass = guiGetText(passEdit)
        triggerServerEvent("onPlayerTryLogin", localPlayer, user, pass)
    end, false)
end

-- Server (login_s.lua)
addEvent("onPlayerTryLogin", true)
addEventHandler("onPlayerTryLogin", root, function(user, pass)
    local player = source
    if checkLogin(user, pass) then
        loadPlayerData(player)
        triggerClientEvent(player, "onLoginSuccess", player)
    end
end)
```

### 4.2 Sistema de Loja
```lua
-- Client (shop_c.lua)
function showShop()
    local shopWindow = guiCreateWindow(0.3, 0.3, 0.4, 0.4, "Loja", true)
    local itemList = guiCreateGridList(0.1, 0.1, 0.8, 0.7, true, shopWindow)
    
    guiGridListAddColumn(itemList, "Item", 0.6)
    guiGridListAddColumn(itemList, "Preço", 0.3)
    
    addEventHandler("onClientGUIClick", itemList, function()
        local item = guiGridListGetSelectedItem(itemList)
        if item then
            triggerServerEvent("onPlayerBuyItem", localPlayer, item)
        end
    end, false)
end

-- Server (shop_s.lua)
addEvent("onPlayerBuyItem", true)
addEventHandler("onPlayerBuyItem", root, function(item)
    local player = source
    if canPlayerBuyItem(player, item) then
        givePlayerItem(player, item)
        takePlayerMoney(player, getItemPrice(item))
        triggerClientEvent(player, "onShopSuccess", player)
    end
end)
```

## 5. Dicas Importantes

### 5.1 Segurança
1. **N Confia no Client**
   - Sempre valida no server
   - Checa valores
   - Previne cheats
   - Protege dados

2. **Dados Sensíveis**
   - Guarda no server
   - N manda pro client
   - Esconde infos
   - Usa hash

3. **Anticheat**
   - Checa valores
   - Monitora ações
   - Detecta hacks
   - Bane trapaceiros

### 5.2 Performance
1. **Network**
   - Manda só oq precisa
   - Comprime dados
   - Usa cache
   - Otimiza sync

2. **Client**
   - Evita loops
   - Usa timers
   - Limita efeitos
   - Otimiza GUI

3. **Server**
   - Cache de dados
   - Queue de tasks
   - Load balance
   - DB otimizado
