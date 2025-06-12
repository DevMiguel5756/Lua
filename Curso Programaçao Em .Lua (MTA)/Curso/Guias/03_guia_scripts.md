# Guia Completo de Scripts MTA:SA - Parte 3: Sistemas Avançados

## 1. Sistemas de IA

### 1.1 Pathfinding A*
```lua
local Pathfinder = {
    nodes = {},
    
    addNode = function(self, id, x, y, z)
        self.nodes[id] = {
            pos = {x = x, y = y, z = z},
            connections = {}
        }
    end,
    
    addConnection = function(self, from, to, weight)
        if not self.nodes[from] or not self.nodes[to] then
            return false
        end
        
        table.insert(self.nodes[from].connections, {
            to = to,
            weight = weight or 1
        })
    end,
    
    heuristic = function(self, node1, node2)
        local pos1 = self.nodes[node1].pos
        local pos2 = self.nodes[node2].pos
        return getDistanceBetweenPoints3D(
            pos1.x, pos1.y, pos1.z,
            pos2.x, pos2.y, pos2.z
        )
    end,
    
    findPath = function(self, start, goal)
        local openSet = {start}
        local cameFrom = {}
        local gScore = {[start] = 0}
        local fScore = {[start] = self:heuristic(start, goal)}
        
        while #openSet > 0 do
            -- Encontra nó com menor fScore
            local current = openSet[1]
            local lowestF = fScore[current]
            local lowestIndex = 1
            
            for i = 2, #openSet do
                local node = openSet[i]
                if fScore[node] < lowestF then
                    current = node
                    lowestF = fScore[node]
                    lowestIndex = i
                end
            end
            
            -- Remove da lista aberta
            table.remove(openSet, lowestIndex)
            
            -- Chegou ao objetivo
            if current == goal then
                local path = {current}
                while cameFrom[current] do
                    current = cameFrom[current]
                    table.insert(path, 1, current)
                end
                return path
            end
            
            -- Explora vizinhos
            for _, connection in ipairs(self.nodes[current].connections) do
                local neighbor = connection.to
                local tentativeG = gScore[current] + connection.weight
                
                if not gScore[neighbor] or tentativeG < gScore[neighbor] then
                    cameFrom[neighbor] = current
                    gScore[neighbor] = tentativeG
                    fScore[neighbor] = gScore[neighbor] + 
                        self:heuristic(neighbor, goal)
                    
                    -- Adiciona à lista aberta se não estiver
                    local found = false
                    for _, node in ipairs(openSet) do
                        if node == neighbor then
                            found = true
                            break
                        end
                    end
                    if not found then
                        table.insert(openSet, neighbor)
                    end
                end
            end
        end
        
        return nil  -- Caminho não encontrado
    end
}
```

### 1.2 Sistema de NPCs Inteligentes
```lua
local NPC = {
    peds = {},
    
    create = function(self, skin, x, y, z)
        local ped = createPed(skin, x, y, z)
        
        self.peds[ped] = {
            state = "idle",
            target = nil,
            path = nil,
            pathIndex = 1,
            lastUpdate = 0,
            behavior = "passive"
        }
        
        return ped
    end,
    
    setState = function(self, ped, state)
        if not self.peds[ped] then return end
        self.peds[ped].state = state
    end,
    
    setBehavior = function(self, ped, behavior)
        if not self.peds[ped] then return end
        self.peds[ped].behavior = behavior
    end,
    
    update = function(self, ped)
        local data = self.peds[ped]
        if not data then return end
        
        local currentTime = getTickCount()
        if currentTime - data.lastUpdate < 100 then return end
        data.lastUpdate = currentTime
        
        -- Atualiza baseado no estado
        if data.state == "idle" then
            self:updateIdle(ped, data)
        elseif data.state == "following" then
            self:updateFollowing(ped, data)
        elseif data.state == "attacking" then
            self:updateAttacking(ped, data)
        elseif data.state == "fleeing" then
            self:updateFleeing(ped, data)
        end
        
        -- Comportamento
        if data.behavior == "aggressive" then
            self:checkForEnemies(ped, data)
        elseif data.behavior == "defensive" then
            self:checkForThreats(ped, data)
        end
    end,
    
    updateIdle = function(self, ped, data)
        -- Movimento aleatório
        if math.random() < 0.1 then
            local x, y, z = getElementPosition(ped)
            local angle = math.random() * 360
            local distance = math.random(5, 15)
            
            local targetX = x + math.cos(angle) * distance
            local targetY = y + math.sin(angle) * distance
            
            setPedRotation(ped, angle)
            setPedControlState(ped, "forwards", true)
        end
    end,
    
    updateFollowing = function(self, ped, data)
        if not isElement(data.target) then
            self:setState(ped, "idle")
            return
        end
        
        local x, y, z = getElementPosition(ped)
        local tx, ty, tz = getElementPosition(data.target)
        local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
        
        if distance > 20 then
            self:setState(ped, "idle")
            return
        end
        
        if distance > 2 then
            local angle = math.atan2(ty - y, tx - x)
            setPedRotation(ped, math.deg(angle))
            setPedControlState(ped, "forwards", true)
        else
            setPedControlState(ped, "forwards", false)
        end
    end,
    
    updateAttacking = function(self, ped, data)
        if not isElement(data.target) then
            self:setState(ped, "idle")
            return
        end
        
        local x, y, z = getElementPosition(ped)
        local tx, ty, tz = getElementPosition(data.target)
        local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
        
        if distance > 20 then
            self:setState(ped, "idle")
            return
        end
        
        -- Ataque
        if distance < 2 then
            setPedControlState(ped, "forwards", false)
            setPedControlState(ped, "fire", true)
        else
            local angle = math.atan2(ty - y, tx - x)
            setPedRotation(ped, math.deg(angle))
            setPedControlState(ped, "forwards", true)
            setPedControlState(ped, "fire", false)
        end
    end,
    
    updateFleeing = function(self, ped, data)
        if not isElement(data.target) then
            self:setState(ped, "idle")
            return
        end
        
        local x, y, z = getElementPosition(ped)
        local tx, ty, tz = getElementPosition(data.target)
        local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
        
        if distance > 30 then
            self:setState(ped, "idle")
            return
        end
        
        -- Foge na direção oposta
        local angle = math.atan2(ty - y, tx - x)
        angle = angle + math.pi  -- Inverte direção
        setPedRotation(ped, math.deg(angle))
        setPedControlState(ped, "forwards", true)
        setPedControlState(ped, "sprint", true)
    end,
    
    checkForEnemies = function(self, ped, data)
        local x, y, z = getElementPosition(ped)
        local players = getElementsByType("player")
        
        for _, player in ipairs(players) do
            local px, py, pz = getElementPosition(player)
            local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
            
            if distance < 15 then
                data.target = player
                self:setState(ped, "attacking")
                break
            end
        end
    end,
    
    checkForThreats = function(self, ped, data)
        local x, y, z = getElementPosition(ped)
        local players = getElementsByType("player")
        
        for _, player in ipairs(players) do
            local px, py, pz = getElementPosition(player)
            local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
            
            if distance < 10 then
                data.target = player
                self:setState(ped, "fleeing")
                break
            end
        end
    end
}

-- Atualização dos NPCs
setTimer(function()
    for ped, _ in pairs(NPC.peds) do
        if isElement(ped) then
            NPC:update(ped)
        else
            NPC.peds[ped] = nil
        end
    end
end, 50, 0)
```

## 2. Física Avançada

### 2.1 Sistema de Colisão Customizado
```lua
local PhysicsSystem = {
    objects = {},
    gravity = 9.81,
    
    addObject = function(self, element, mass, friction)
        if not isElement(element) then return end
        
        self.objects[element] = {
            mass = mass or 1.0,
            friction = friction or 0.5,
            velocity = {x = 0, y = 0, z = 0},
            acceleration = {x = 0, y = 0, z = 0},
            forces = {}
        }
    end,
    
    applyForce = function(self, element, fx, fy, fz)
        local obj = self.objects[element]
        if not obj then return end
        
        table.insert(obj.forces, {x = fx, y = fy, z = fz})
    end,
    
    applyImpulse = function(self, element, ix, iy, iz)
        local obj = self.objects[element]
        if not obj then return end
        
        obj.velocity.x = obj.velocity.x + ix / obj.mass
        obj.velocity.y = obj.velocity.y + iy / obj.mass
        obj.velocity.z = obj.velocity.z + iz / obj.mass
    end,
    
    update = function(self, dt)
        for element, obj in pairs(self.objects) do
            if isElement(element) then
                -- Soma forças
                local fx, fy, fz = 0, 0, -obj.mass * self.gravity
                
                for _, force in ipairs(obj.forces) do
                    fx = fx + force.x
                    fy = fy + force.y
                    fz = fz + force.z
                end
                
                -- Calcula aceleração (F = ma)
                obj.acceleration.x = fx / obj.mass
                obj.acceleration.y = fy / obj.mass
                obj.acceleration.z = fz / obj.mass
                
                -- Atualiza velocidade
                obj.velocity.x = obj.velocity.x + obj.acceleration.x * dt
                obj.velocity.y = obj.velocity.y + obj.acceleration.y * dt
                obj.velocity.z = obj.velocity.z + obj.acceleration.z * dt
                
                -- Aplica fricção
                local friction = math.pow(1 - obj.friction, dt)
                obj.velocity.x = obj.velocity.x * friction
                obj.velocity.y = obj.velocity.y * friction
                obj.velocity.z = obj.velocity.z * friction
                
                -- Atualiza posição
                local x, y, z = getElementPosition(element)
                setElementPosition(element,
                    x + obj.velocity.x * dt,
                    y + obj.velocity.y * dt,
                    z + obj.velocity.z * dt
                )
                
                -- Limpa forças
                obj.forces = {}
            else
                self.objects[element] = nil
            end
        end
    end,
    
    checkCollision = function(self, elem1, elem2)
        if not isElement(elem1) or not isElement(elem2) then
            return false
        end
        
        local x1, y1, z1 = getElementPosition(elem1)
        local x2, y2, z2 = getElementPosition(elem2)
        
        -- Pega boundingbox
        local minX1, minY1, minZ1, maxX1, maxY1, maxZ1 = getElementBoundingBox(elem1)
        local minX2, minY2, minZ2, maxX2, maxY2, maxZ2 = getElementBoundingBox(elem2)
        
        -- Ajusta para posição global
        minX1, minY1, minZ1 = x1 + minX1, y1 + minY1, z1 + minZ1
        maxX1, maxY1, maxZ1 = x1 + maxX1, y1 + maxY1, z1 + maxZ1
        
        minX2, minY2, minZ2 = x2 + minX2, y2 + minY2, z2 + minZ2
        maxX2, maxY2, maxZ2 = x2 + maxX2, y2 + maxY2, z2 + maxZ2
        
        -- Verifica colisão AABB
        return (minX1 <= maxX2 and maxX1 >= minX2) and
               (minY1 <= maxY2 and maxY1 >= minY2) and
               (minZ1 <= maxZ2 and maxZ1 >= minZ2)
    end,
    
    resolveCollision = function(self, elem1, elem2)
        local obj1 = self.objects[elem1]
        local obj2 = self.objects[elem2]
        
        if not obj1 or not obj2 then return end
        
        local x1, y1, z1 = getElementPosition(elem1)
        local x2, y2, z2 = getElementPosition(elem2)
        
        -- Calcula normal da colisão
        local nx = x2 - x1
        local ny = y2 - y1
        local nz = z2 - z1
        
        local len = math.sqrt(nx*nx + ny*ny + nz*nz)
        if len == 0 then return end
        
        nx = nx / len
        ny = ny / len
        nz = nz / len
        
        -- Velocidade relativa
        local rvx = obj2.velocity.x - obj1.velocity.x
        local rvy = obj2.velocity.y - obj1.velocity.y
        local rvz = obj2.velocity.z - obj1.velocity.z
        
        -- Velocidade relativa ao longo da normal
        local velAlongNormal = rvx*nx + rvy*ny + rvz*nz
        
        -- Se objetos se afastando, ignora
        if velAlongNormal > 0 then return end
        
        -- Coeficiente de restituição
        local e = 0.5
        
        -- Impulso
        local j = -(1 + e) * velAlongNormal
        j = j / (1/obj1.mass + 1/obj2.mass)
        
        -- Aplica impulso
        local ix = j * nx
        local iy = j * ny
        local iz = j * nz
        
        self:applyImpulse(elem1, -ix, -iy, -iz)
        self:applyImpulse(elem2, ix, iy, iz)
    end
}

-- Update loop
local lastTime = getTickCount()
addEventHandler("onClientRender", root,
    function()
        local currentTime = getTickCount()
        local dt = (currentTime - lastTime) / 1000
        lastTime = currentTime
        
        PhysicsSystem:update(dt)
        
        -- Checa colisões
        local checked = {}
        for elem1, _ in pairs(PhysicsSystem.objects) do
            checked[elem1] = true
            for elem2, _ in pairs(PhysicsSystem.objects) do
                if not checked[elem2] then
                    if PhysicsSystem:checkCollision(elem1, elem2) then
                        PhysicsSystem:resolveCollision(elem1, elem2)
                    end
                end
            end
        end
    end
)
```

## 3. Networking em Tempo Real

### 3.1 Sistema de Interpolação
```lua
local NetworkInterpolator = {
    elements = {},
    
    addElement = function(self, element)
        self.elements[element] = {
            lastUpdate = 0,
            targetPos = {x = 0, y = 0, z = 0},
            currentPos = {x = 0, y = 0, z = 0},
            targetRot = {x = 0, y = 0, z = 0},
            currentRot = {x = 0, y = 0, z = 0}
        }
    end,
    
    updateElement = function(self, element, x, y, z, rx, ry, rz)
        local data = self.elements[element]
        if not data then return end
        
        -- Atualiza posição atual
        data.currentPos.x, data.currentPos.y, data.currentPos.z =
            getElementPosition(element)
        data.currentRot.x, data.currentRot.y, data.currentRot.z =
            getElementRotation(element)
        
        -- Define alvo
        data.targetPos = {x = x, y = y, z = z}
        data.targetRot = {x = rx, y = ry, z = rz}
        
        data.lastUpdate = getTickCount()
    end,
    
    interpolate = function(self, element, alpha)
        local data = self.elements[element]
        if not data then return end
        
        -- Interpola posição
        local x = data.currentPos.x + (data.targetPos.x - data.currentPos.x) * alpha
        local y = data.currentPos.y + (data.targetPos.y - data.currentPos.y) * alpha
        local z = data.currentPos.z + (data.targetPos.z - data.currentPos.z) * alpha
        
        -- Interpola rotação
        local rx = data.currentRot.x + (data.targetRot.x - data.currentRot.x) * alpha
        local ry = data.currentRot.y + (data.targetRot.y - data.currentRot.y) * alpha
        local rz = data.currentRot.z + (data.targetRot.z - data.currentRot.z) * alpha
        
        -- Aplica
        setElementPosition(element, x, y, z)
        setElementRotation(element, rx, ry, rz)
    end,
    
    update = function(self)
        local currentTime = getTickCount()
        
        for element, data in pairs(self.elements) do
            if isElement(element) then
                local timeDiff = currentTime - data.lastUpdate
                local alpha = math.min(1, timeDiff / 100)  -- 100ms interpolação
                
                self:interpolate(element, alpha)
            else
                self.elements[element] = nil
            end
        end
    end
}

-- Update loop
addEventHandler("onClientRender", root,
    function()
        NetworkInterpolator:update()
    end
)
```

## 4. Exercícios Expert

1. Implemente um sistema de física de corda
2. Crie um sistema de IA para perseguições de carros
3. Desenvolva um sistema de dano realista
4. Implemente um sistema de clima dinâmico
5. Crie um sistema de partículas avançado

## 5. Próximos Passos

Continue para a Parte 4 do guia, onde abordaremos:
1. Sistemas de renderização avançada
2. Shaders complexos
3. Otimização extrema
4. Técnicas de anti-cheat
5. Sistemas distribuídos
