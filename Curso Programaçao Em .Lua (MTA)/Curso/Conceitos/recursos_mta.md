# Recursos no MTA:SA

Fala dev! Bora aprender sobre recursos no MTA:SA? São tipo os mods do server!

## 1. O que são Recursos?

Recursos são pacotes de:
- Scripts Lua
- Assets (texturas, sons)
- Meta info
- Configs

São a base pra tudo no server!

## 2. Estrutura Básica

### 2.1 Files Principais
```
meu_resource/
  ├── meta.xml      # Config principal
  ├── client.lua    # Roda no PC do player
  ├── server.lua    # Roda no servidor
  └── assets/       # Texturas, sons, etc
```

### 2.2 Meta.xml
```xml
<meta>
    <!-- Info básica -->
    <info author="SeuNome" name="MeuResource" version="1.0"/>
    
    <!-- Scripts -->
    <script src="server.lua" type="server"/>
    <script src="client.lua" type="client"/>
    
    <!-- Files -->
    <file src="assets/som.mp3"/>
    <file src="assets/textura.png"/>
    
    <!-- Exports -->
    <export function="minhaFunc" type="server"/>
    <export function="outraFunc" type="client"/>
</meta>
```

## 3. Como Usar

### 3.1 Criar Resource
1. **Setup**
   ```lua
   -- Pasta do resource
   meu_resource/
     ├── meta.xml
     ├── client.lua
     └── server.lua
   ```

2. **Meta.xml**
   ```xml
   <meta>
       <info author="Você" name="MeuMod" version="1.0"/>
       <script src="server.lua" type="server"/>
       <script src="client.lua" type="client"/>
   </meta>
   ```

3. **Scripts**
   ```lua
   -- server.lua
   function sayHi(player)
       outputChatBox("Oi " .. getPlayerName(player), player)
   end
   addCommandHandler("oi", sayHi)
   
   -- client.lua
   addEventHandler("onClientResourceStart", resourceRoot, function()
       outputChatBox("Resource iniciado!")
   end)
   ```

### 3.2 Start/Stop
```lua
-- Start
startResource(getResourceFromName("meu_resource"))

-- Stop
stopResource(getResourceFromName("meu_resource"))

-- Restart
restartResource(getResourceFromName("meu_resource"))
```

## 4. Compartilhando Funcs

### 4.1 Exports
```lua
-- server.lua
function getPlayerMoney(player)
    return getElementData(player, "money") or 0
end

-- meta.xml
<export function="getPlayerMoney" type="server"/>

-- outro_resource/server.lua
local money = exports.meu_resource:getPlayerMoney(player)
```

### 4.2 Events
```lua
-- server.lua
addEvent("onMoneyChange", true)
function setPlayerMoney(player, value)
    setElementData(player, "money", value)
    triggerEvent("onMoneyChange", player, value)
end

-- client.lua
addEventHandler("onMoneyChange", root, function(value)
    outputChatBox("Dinheiro: $" .. value)
end)
```

## 5. Assets

### 5.1 Files
```lua
-- meta.xml
<file src="assets/som.mp3"/>
<file src="assets/img.png"/>

-- client.lua
local som = playSound("assets/som.mp3")
local tex = dxCreateTexture("assets/img.png")
```

### 5.2 Download
```lua
-- client.lua
addEventHandler("onClientResourceStart", resourceRoot, function()
    downloadFile("assets/som.mp3")
    downloadFile("assets/img.png")
end)

addEventHandler("onClientFileDownloadComplete", root, function(file)
    outputChatBox("Baixou: " .. file)
end)
```

## 6. Debug

### 6.1 Erros Comuns
1. **Meta.xml**
   - Tag errada
   - Path errado
   - Falta de permissão
   - XML mal formatado

2. **Scripts**
   - Syntax error
   - File n existe
   - Func undefined
   - Resource crash

### 6.2 Debug Tools
1. **Client**
   - F8 console
   - Debug output
   - Error logs
   - Resource info

2. **Server**
   - Server logs
   - Admin panel
   - Resource manager
   - Error reports

## 7. Dicas Importantes

### 7.1 Performance
1. **Otimiza**
   - Cache data
   - Limita events
   - Comprime assets
   - Clean code

2. **Network**
   - Manda só oq precisa
   - Comprime dados
   - Usa cache local
   - Otimiza sync

### 7.2 Organização
1. **Files**
   - Separa por tipo
   - Usa pastas
   - Nomeia bem
   - Documenta

2. **Code**
   - Comenta
   - Formata
   - Modulariza
   - Version control

## 8. Exemplos Práticos

### 8.1 Resource Simples
```lua
-- meta.xml
<meta>
    <info author="Você" name="TesteMod" version="1.0"/>
    <script src="server.lua" type="server"/>
    <script src="client.lua" type="client"/>
</meta>

-- server.lua
function giveMoney(player, cmd, amount)
    amount = tonumber(amount) or 0
    givePlayerMoney(player, amount)
    outputChatBox("Recebeu $" .. amount, player)
end
addCommandHandler("money", giveMoney)

-- client.lua
addEventHandler("onClientResourceStart", resourceRoot, function()
    local scr = guiCreateWindow(0.4, 0.4, 0.2, 0.2, "Teste", true)
    local btn = guiCreateButton(0.3, 0.5, 0.4, 0.2, "Money!", true, scr)
    
    addEventHandler("onClientGUIClick", btn, function()
        triggerServerEvent("giveMoney", localPlayer, 1000)
    end, false)
end)
```

### 8.2 Resource com Assets
```lua
-- meta.xml
<meta>
    <info author="Você" name="CarroMod" version="1.0"/>
    <script src="server.lua" type="server"/>
    <script src="client.lua" type="client"/>
    <file src="assets/carro.txd"/>
    <file src="assets/som.mp3"/>
</meta>

-- server.lua
function spawnCar(player)
    local x, y, z = getElementPosition(player)
    local veh = createVehicle(411, x + 3, y, z)
    warpPedIntoVehicle(player, veh)
end
addCommandHandler("car", spawnCar)

-- client.lua
local sound = nil

addEventHandler("onClientResourceStart", resourceRoot, function()
    local txd = engineLoadTXD("assets/carro.txd")
    engineImportTXD(txd, 411)
    
    sound = playSound("assets/som.mp3", true)
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    if sound then
        destroyElement(sound)
    end
end)
