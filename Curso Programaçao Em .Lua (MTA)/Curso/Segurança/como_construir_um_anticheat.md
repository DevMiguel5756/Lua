# Como Criar um Anti-Cheat do Zero no MTA:SA

E aí! Vamo aprender a criar um sistema anti-cheat pro seu servidor? Bora lá! 👊

## 1. Introdução
### 1.1 O que é um Anti-Cheat e pq vc precisa de um?
Pensa num sistema q vai ser tipo um segurança do seu servidor, saca? Ele vai:
- Pegar aquela galera q tá usando hack/cheat (ngm gosta de cheater né? 😠)
- Manter seu servidor limpinho e justo pra geral
- Garantir q todo mundo tá jogando legal

### 1.2 Tipos de Cheats + Comuns
Esses são os chatos q vc vai ter q lidar:
1. **Speed Hack**: Aquele cara q tá correndo + rápido q o Flash
2. **Teleport**: O maluco q tá pulando igual DBZ pelo mapa
3. **Wall Hack**: O espertinho q tá vendo atravez da parede
4. **Weapon Hack**: Galera q tá spawnando arma ou mudando munição
5. **Fly Hack**: O cara q acha q é pombo e tá voando por aí
6. **Aimbot**: Aquele mlk q "do nada" virou pro player
7. **Health/Armor Hack**: Os imortal q nunca morre
8. **Vehicle Hack**: Os cara q transforma Fusca em Ferrari

## 2. Montando o Sistema

### 2.1 A Base do Sistema
Aqui é a estrutura básica do nosso anti-cheat. É tipo a fundação da casa, tem q ser firmeza:

```lua
-- Aqui é onde a mágica acontece
local AntiCheat = {
    checks = {},        -- Guarda as funções q vão verificar os cheats
    violations = {},    -- Marca os vacilões q foram pegos
    thresholds = {},    -- Qnts vezes o cara pode vacilar antes de rodar
    logs = {},         -- Histórico da mulecagem
    config = {         -- As config do sistema
        enabled = true,
        debugMode = false,
        logToFile = true,
        logPath = "logs/anticheat.log",
        maxViolations = 10,
        checkInterval = 1000, -- ms
        punishmentLevels = {
            [1] = "warn",    -- 1-3 vacilo = aviso
            [2] = "kick",    -- 4-7 vacilo = kick
            [3] = "ban"      -- 8+ vacilo = ban
        }
    }
}
```

### 2.2 Sistema de Logs (pq vc precisa saber oq tá rolando)
```lua
-- Função pra criar arquivo de log se n existir
function AntiCheat:initializeLogging()
    if not fileExists(self.config.logPath) then
        local file = fileCreate(self.config.logPath)
        fileClose(file)
    end
end

-- Função pra salvar os logs (MUITO importante!)
function AntiCheat:log(message, level)
    level = level or "INFO"
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local logMessage = string.format("[%s] [%s] %s", timestamp, level, message)
    
    -- Mostra no console (pra vc ver na hora)
    outputDebugString(logMessage)
    
    -- Salva no arquivo (pra vc ver dps)
    if self.config.logToFile then
        local file = fileOpen(self.config.logPath)
        if file then
            fileSetPos(file, fileGetSize(file))
            fileWrite(file, logMessage .. "\n")
            fileClose(file)
        end
    end
end
```

## 3. Os Checks (A Parte Importante!)

### 3.1 Sistema Base dos Checks
Aqui é onde a gente configura como vai verificar os cheats:

```lua
-- Adiciona um novo check no sistema
function AntiCheat:addCheck(name, check, threshold, priority)
    self.checks[name] = {
        func = check,
        threshold = threshold or 3,  -- 3 chances antes de agir
        priority = priority or 1,    -- qão importante é esse check
        enabled = true
    end
end

-- Liga um check
function AntiCheat:enableCheck(name)
    if self.checks[name] then
        self.checks[name].enabled = true
        self:log("Check ligado: " .. name, "INFO")
    end
end

-- Desliga um check
function AntiCheat:disableCheck(name)
    if self.checks[name] then
        self.checks[name].enabled = false
        self:log("Check desligado: " .. name, "INFO")
    end
end
```

### 3.2 Os Checks na Prática

#### 3.2.1 Pegando os Speed Hacker
```lua
-- Função pra pegar qm tá usando speed hack
function AntiCheat:speedHackCheck(player)
    if not isElement(player) then return end
    
    -- Pega a velocidade atual do player
    local x, y, z = getElementPosition(player)
    local vx, vy, vz = getElementVelocity(player)
    local speed = math.sqrt(vx*vx + vy*vy + vz*vz)
    
    -- Define velocidade máxima baseado na situação
    local maxSpeed
    if isPedInVehicle(player) then
        local vehicle = getPedOccupiedVehicle(player)
        local model = getElementModel(vehicle)
        maxSpeed = self:getVehicleMaxSpeed(model)
    else
        if isPedDucked(player) then
            maxSpeed = 0.2  -- Agachado
        elseif isPedInWater(player) then
            maxSpeed = 0.3  -- Nadando
        else
            maxSpeed = 0.45 -- Correndo
        end
    end
    
    -- Se passar do limite + 20%, já era
    if speed > maxSpeed * 1.2 then
        return true, {
            speed = speed,
            maxAllowed = maxSpeed,
            position = {x = x, y = y, z = z}
        }
    end
    
    return false
end
```

#### 3.2.2 Teleport Detection
```lua
function AntiCheat:teleportCheck(player)
    if not isElement(player) then return end
    
    local lastPos = getElementData(player, "ac.lastPosition")
    local x, y, z = getElementPosition(player)
    local currentTime = getTickCount()
    
    if lastPos then
        local timeDiff = currentTime - lastPos.time
        local distance = getDistanceBetweenPoints3D(
            lastPos.x, lastPos.y, lastPos.z,
            x, y, z
        )
        
        -- Calcula velocidade máxima permitida
        local maxDistance = (timeDiff / 1000) * 
            (isPedInVehicle(player) and 300 or 50)
        
        if distance > maxDistance then
            return true, {
                distance = distance,
                maxAllowed = maxDistance,
                timeDiff = timeDiff,
                from = lastPos,
                to = {x = x, y = y, z = z}
            }
        end
    end
    
    setElementData(player, "ac.lastPosition", {
        x = x, y = y, z = z,
        time = currentTime
    })
    
    return false
end
```

#### 3.2.3 Wall Hack Detection
```lua
function AntiCheat:wallHackCheck(player)
    if not isElement(player) then return end
    
    local x, y, z = getElementPosition(player)
    local _, _, _, hit = processLineOfSight(
        x, y, z,
        x, y, z - 1,
        true,   -- Check buildings
        true,   -- Check vehicles
        false,  -- Check players
        true,   -- Check objects
        false,  -- Ignore some materials
        player  -- The element to ignore
    )
    
    if not hit and not isPedInVehicle(player) then
        return true, {
            position = {x = x, y = y, z = z}
        }
    end
    
    return false
end
```

#### 3.2.4 Weapon Hack Detection
```lua
function AntiCheat:weaponCheck(player)
    if not isElement(player) then return end
    
    local weapon = getPedWeapon(player)
    local ammo = getPedTotalAmmo(player)
    local slot = getPedWeaponSlot(player)
    
    -- Verifica armas permitidas
    if not self:isWeaponAllowed(weapon) then
        return true, {
            weapon = weapon,
            type = "illegal_weapon"
        }
    end
    
    -- Verifica munição máxima
    local maxAmmo = self:getMaxAmmo(weapon)
    if ammo > maxAmmo then
        return true, {
            weapon = weapon,
            ammo = ammo,
            maxAllowed = maxAmmo,
            type = "illegal_ammo"
        }
    end
    
    -- Verifica troca rápida de armas
    local lastWeaponSwitch = getElementData(player, "ac.lastWeaponSwitch")
    local currentTime = getTickCount()
    
    if lastWeaponSwitch and 
       (currentTime - lastWeaponSwitch.time) < 100 and
       lastWeaponSwitch.slot ~= slot then
        return true, {
            type = "weapon_switch_speed",
            timeDiff = currentTime - lastWeaponSwitch.time
        }
    end
    
    setElementData(player, "ac.lastWeaponSwitch", {
        time = currentTime,
        slot = slot
    })
    
    return false
end
```

## 4. Sistema de Punições

### 4.1 Gerenciamento de Violações
```lua
function AntiCheat:reportViolation(player, checkName, data)
    if not self.violations[player] then
        self.violations[player] = {}
    end
    
    if not self.violations[player][checkName] then
        self.violations[player][checkName] = {
            count = 0,
            firstViolation = getTickCount(),
            violations = {}
        }
    end
    
    local violation = self.violations[player][checkName]
    violation.count = violation.count + 1
    
    -- Adiciona detalhes da violação
    table.insert(violation.violations, {
        time = getTickCount(),
        data = data
    })
    
    -- Log da violação
    self:log(string.format(
        "Violation detected - Player: %s, Check: %s, Count: %d",
        getPlayerName(player), checkName, violation.count
    ), "WARNING")
    
    -- Decide punição
    self:decidePunishment(player, checkName)
end

function AntiCheat:decidePunishment(player, checkName)
    local violation = self.violations[player][checkName]
    local count = violation.count
    
    -- Calcula nível de punição
    local punishmentLevel
    if count >= 8 then
        punishmentLevel = 3 -- Ban
    elseif count >= 4 then
        punishmentLevel = 2 -- Kick
    else
        punishmentLevel = 1 -- Warn
    end
    
    -- Aplica punição
    self:applyPunishment(player, checkName, punishmentLevel, violation)
end
```

### 4.2 Sistema de Punições
```lua
function AntiCheat:applyPunishment(player, checkName, level, violation)
    local punishmentType = self.config.punishmentLevels[level]
    local reason = string.format(
        "Anti-Cheat: %s (Violações: %d)",
        checkName, violation.count
    )
    
    if punishmentType == "warn" then
        -- Aviso ao jogador
        outputChatBox("Aviso: Comportamento suspeito detectado!", 
            player, 255, 0, 0)
        
        -- Aviso para admins
        self:notifyAdmins(string.format(
            "AVISO: %s suspeito de %s",
            getPlayerName(player), checkName
        ))
        
    elseif punishmentType == "kick" then
        -- Kick com razão
        kickPlayer(player, reason)
        
        -- Notifica admins
        self:notifyAdmins(string.format(
            "KICK: %s foi kickado por %s",
            getPlayerName(player), reason
        ))
        
    elseif punishmentType == "ban" then
        -- Ban permanente
        banPlayer(player, false, false, true, reason)
        
        -- Notifica admins
        self:notifyAdmins(string.format(
            "BAN: %s foi banido por %s",
            getPlayerName(player), reason
        ))
    end
    
    -- Log da punição
    self:log(string.format(
        "Punishment applied - Player: %s, Type: %s, Reason: %s",
        getPlayerName(player), punishmentType, reason
    ), "WARNING")
end
```

## 5. Inicialização e Uso

### 5.1 Inicialização do Sistema
```lua
function AntiCheat:initialize()
    -- Inicializa sistema de logs
    self:initializeLogging()
    
    -- Adiciona checks padrão
    self:addCheck("speedhack", self.speedHackCheck, 3, 1)
    self:addCheck("teleport", self.teleportCheck, 3, 1)
    self:addCheck("wallhack", self.wallHackCheck, 2, 2)
    self:addCheck("weapon", self.weaponCheck, 2, 1)
    
    -- Inicia timer de verificação
    self.checkTimer = setTimer(function()
        self:runChecks()
    end, self.config.checkInterval, 0)
    
    -- Log de inicialização
    self:log("Anti-Cheat system initialized", "INFO")
end

function AntiCheat:runChecks()
    if not self.config.enabled then return end
    
    -- Organiza checks por prioridade
    local sortedChecks = {}
    for name, check in pairs(self.checks) do
        if check.enabled then
            table.insert(sortedChecks, {
                name = name,
                check = check
            })
        end
    end
    
    table.sort(sortedChecks, function(a, b)
        return a.check.priority < b.check.priority
    end)
    
    -- Executa checks em todos os jogadores
    for _, player in ipairs(getElementsByType("player")) do
        for _, check in ipairs(sortedChecks) do
            local isViolation, data = check.check.func(self, player)
            if isViolation then
                self:reportViolation(player, check.name, data)
            end
        end
    end
end
```

### 5.2 Funções Auxiliares
```lua
function AntiCheat:getVehicleMaxSpeed(model)
    -- Velocidades máximas por modelo de veículo
    local maxSpeeds = {
        [411] = 2.5,  -- Infernus
        [429] = 2.3,  -- Banshee
        [541] = 2.4,  -- Bullet
        [415] = 2.2   -- Cheetah
        -- Adicione mais veículos conforme necessário
    }
    
    return maxSpeeds[model] or 2.0 -- Velocidade padrão
end

function AntiCheat:isWeaponAllowed(weapon)
    local allowedWeapons = {
        [22] = true, -- Pistol
        [23] = true, -- Silenced
        [24] = true, -- Deagle
        [25] = true, -- Shotgun
        [29] = true, -- MP5
        [31] = true, -- M4
        [30] = true  -- AK-47
    }
    
    return allowedWeapons[weapon] or false
end

function AntiCheat:getMaxAmmo(weapon)
    local maxAmmo = {
        [22] = 17,   -- Pistol
        [23] = 17,   -- Silenced
        [24] = 7,    -- Deagle
        [25] = 1,    -- Shotgun
        [29] = 30,   -- MP5
        [31] = 30,   -- M4
        [30] = 30    -- AK-47
    }
    
    return maxAmmo[weapon] or 100
end

function AntiCheat:notifyAdmins(message)
    for _, player in ipairs(getElementsByType("player")) do
        if hasObjectPermissionTo(player, "function.kickPlayer") then
            outputChatBox("[AC] " .. message, player, 255, 0, 0)
        end
    end
end
```

## 6. Boas Práticas e Considerações

### 6.1 Validação de Dados
- Sempre valide dados recebidos do cliente
- Use checksums para verificar integridade
- Implemente rate limiting para evitar flood
- Mantenha dados sensíveis no servidor

### 6.2 Performance
- Otimize checks para minimizar impacto
- Use timers adequados para cada tipo de check
- Implemente cache quando apropriado
- Priorize checks mais importantes

### 6.3 Segurança
- Nunca confie em dados do cliente
- Encripte comunicações sensíveis
- Mantenha logs detalhados
- Implemente sistema de backup

### 6.4 Manutenção
- Atualize regularmente os checks
- Monitore falsos positivos
- Mantenha uma lista de jogadores confiáveis
- Faça backup regular dos logs
