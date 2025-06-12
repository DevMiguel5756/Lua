# Eventos de Veículo no MTA:SA - Parte 2

## Sistemas Avançados

### 1. Sistema de Corridas
```lua
local RaceSystem = {
    corridas = {},
    
    criarCorrida = function(self, nome, checkpoints)
        local corrida = {
            nome = nome,
            checkpoints = checkpoints,
            participantes = {},
            estado = "aguardando",
            tempoInicio = 0
        }
        
        -- Cria markers e blips
        self:criarCheckpoints(corrida)
        
        -- Adiciona handlers
        self:adicionarHandlers(corrida)
        
        table.insert(self.corridas, corrida)
        return #self.corridas
    end,
    
    criarCheckpoints = function(self, corrida)
        corrida.markers = {}
        corrida.blips = {}
        
        for i, pos in ipairs(corrida.checkpoints) do
            -- Cria marker
            local marker = createMarker(pos.x, pos.y, pos.z, "checkpoint")
            table.insert(corrida.markers, marker)
            
            -- Cria blip
            local blip = createBlip(pos.x, pos.y, pos.z)
            table.insert(corrida.blips, blip)
            
            -- Handler de checkpoint
            addEventHandler("onMarkerHit", marker,
                function(element)
                    if getElementType(element) == "vehicle" then
                        self:checkpointAtingido(corrida, element, i)
                    end
                end
            )
        end
    end,
    
    adicionarParticipante = function(self, corrida, player, veiculo)
        corrida.participantes[player] = {
            veiculo = veiculo,
            checkpoint = 0,
            tempoInicio = 0,
            tempoTotal = 0
        }
        
        -- Prepara veículo
        fixVehicle(veiculo)
        setElementHealth(veiculo, 1000)
        
        -- Posiciona no início
        local start = corrida.checkpoints[1]
        setElementPosition(veiculo, start.x, start.y, start.z)
    end,
    
    iniciarCorrida = function(self, corrida)
        corrida.estado = "contagem"
        corrida.tempoInicio = getTickCount()
        
        -- Contagem regressiva
        local contagem = 3
        local timer = setTimer(function()
            if contagem > 0 then
                for player in pairs(corrida.participantes) do
                    outputChatBox(tostring(contagem), player)
                end
                contagem = contagem - 1
            else
                -- Inicia corrida
                corrida.estado = "rodando"
                for player, dados in pairs(corrida.participantes) do
                    dados.tempoInicio = getTickCount()
                    outputChatBox("GO!", player)
                    setVehicleEngineState(dados.veiculo, true)
                end
            end
        end, 1000, 4)
    end,
    
    checkpointAtingido = function(self, corrida, veiculo, checkpoint)
        local player = getVehicleController(veiculo)
        if not player then return end
        
        local dados = corrida.participantes[player]
        if not dados then return end
        
        -- Verifica sequência
        if checkpoint == dados.checkpoint + 1 then
            dados.checkpoint = checkpoint
            
            -- Verifica fim
            if checkpoint == #corrida.checkpoints then
                self:finalizarCorrida(corrida, player)
            else
                outputChatBox("Checkpoint " .. checkpoint .. "/" .. #corrida.checkpoints, player)
            end
        end
    end,
    
    finalizarCorrida = function(self, corrida, vencedor)
        -- Calcula tempo
        local dados = corrida.participantes[vencedor]
        dados.tempoTotal = getTickCount() - dados.tempoInicio
        
        -- Anuncia vencedor
        for player in pairs(corrida.participantes) do
            outputChatBox(getPlayerName(vencedor) .. " venceu! Tempo: " .. 
                math.floor(dados.tempoTotal / 1000) .. "s", player)
        end
        
        -- Limpa corrida
        self:limparCorrida(corrida)
    end,
    
    limparCorrida = function(self, corrida)
        -- Destroi markers e blips
        for _, marker in ipairs(corrida.markers) do
            if isElement(marker) then destroyElement(marker) end
        end
        for _, blip in ipairs(corrida.blips) do
            if isElement(blip) then destroyElement(blip) end
        end
        
        -- Remove corrida
        for i, c in ipairs(self.corridas) do
            if c == corrida then
                table.remove(self.corridas, i)
                break
            end
        end
    end
}
```

### 2. Sistema de Perseguição
```lua
local ChaseSystem = {
    perseguicoes = {},
    
    iniciarPerseguicao = function(self, suspeito, policial)
        local perseguicao = {
            suspeito = suspeito,
            policiais = {[policial] = true},
            inicio = getTickCount(),
            nivel = 1,
            distancia = 0
        }
        
        -- Adiciona blips
        self:criarBlips(perseguicao)
        
        -- Inicia timers
        self:iniciarTimers(perseguicao)
        
        table.insert(self.perseguicoes, perseguicao)
        return #self.perseguicoes
    end,
    
    criarBlips = function(self, perseguicao)
        -- Blip do suspeito
        perseguicao.blipSuspeito = createBlip(0, 0, 0, 0, 2, 255, 0, 0, 255)
        attachElements(perseguicao.blipSuspeito, 
            getPlayerVehicle(perseguicao.suspeito))
        
        -- Blips visíveis apenas para policiais
        for policial in pairs(perseguicao.policiais) do
            setElementVisibleTo(perseguicao.blipSuspeito, policial, true)
        end
    end,
    
    iniciarTimers = function(self, perseguicao)
        -- Atualização de nível
        setTimer(function()
            self:atualizarNivel(perseguicao)
        end, 5000, 0)
        
        -- Verificação de distância
        setTimer(function()
            self:verificarDistancia(perseguicao)
        end, 1000, 0)
    end,
    
    atualizarNivel = function(self, perseguicao)
        -- Aumenta nível baseado no tempo
        local tempoDecorrido = getTickCount() - perseguicao.inicio
        perseguicao.nivel = math.min(5, math.floor(tempoDecorrido / 60000) + 1)
        
        -- Aplica efeitos do nível
        self:aplicarEfeitosNivel(perseguicao)
    end,
    
    aplicarEfeitosNivel = function(self, perseguicao)
        local veiculo = getPlayerVehicle(perseguicao.suspeito)
        
        -- Efeitos baseados no nível
        if perseguicao.nivel >= 2 then
            -- Nível 2: Helicóptero
            self:spawnarHelicoptero(perseguicao)
        end
        if perseguicao.nivel >= 3 then
            -- Nível 3: Bloqueios
            self:criarBloqueios(perseguicao)
        end
        if perseguicao.nivel >= 4 then
            -- Nível 4: Atiradores
            self:spawnarAtiradores(perseguicao)
        end
        if perseguicao.nivel >= 5 then
            -- Nível 5: Veículos especiais
            self:spawnarVeiculosEspeciais(perseguicao)
        end
    end,
    
    verificarDistancia = function(self, perseguicao)
        local veiculo = getPlayerVehicle(perseguicao.suspeito)
        if not veiculo then return end
        
        -- Verifica distância para cada policial
        local x, y, z = getElementPosition(veiculo)
        local policialProximo = false
        
        for policial in pairs(perseguicao.policiais) do
            local px, py, pz = getElementPosition(policial)
            local distancia = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
            
            if distancia < 100 then
                policialProximo = true
                break
            end
        end
        
        -- Se nenhum policial próximo, termina perseguição
        if not policialProximo then
            self:finalizarPerseguicao(perseguicao, "fuga")
        end
    end,
    
    finalizarPerseguicao = function(self, perseguicao, motivo)
        -- Notifica todos
        local mensagem = getPlayerName(perseguicao.suspeito)
        if motivo == "fuga" then
            mensagem = mensagem .. " escapou da polícia!"
        elseif motivo == "preso" then
            mensagem = mensagem .. " foi preso!"
        end
        
        for policial in pairs(perseguicao.policiais) do
            outputChatBox(mensagem, policial)
        end
        outputChatBox(mensagem, perseguicao.suspeito)
        
        -- Limpa perseguição
        self:limparPerseguicao(perseguicao)
    end,
    
    limparPerseguicao = function(self, perseguicao)
        -- Remove blips
        if isElement(perseguicao.blipSuspeito) then
            destroyElement(perseguicao.blipSuspeito)
        end
        
        -- Remove perseguição
        for i, p in ipairs(self.perseguicoes) do
            if p == perseguicao then
                table.remove(self.perseguicoes, i)
                break
            end
        end
    end,
    
    -- Funções auxiliares
    spawnarHelicoptero = function(self, perseguicao)
        local x, y, z = getElementPosition(getPlayerVehicle(perseguicao.suspeito))
        local heli = createVehicle(497, x, y, z + 20)  -- Helicopter
        
        -- Configura helicóptero
        setHelicopterRotorSpeed(heli, 0.2)
        
        -- AI para seguir suspeito
        -- Implementar AI
    end,
    
    criarBloqueios = function(self, perseguicao)
        local x, y, z = getElementPosition(getPlayerVehicle(perseguicao.suspeito))
        
        -- Cria carros de polícia em bloqueio
        for i = 1, 3 do
            local veiculo = createVehicle(596, x + (i * 5), y, z)  -- Police Car
            setVehicleLocked(veiculo, true)
        end
    end,
    
    spawnarAtiradores = function(self, perseguicao)
        local x, y, z = getElementPosition(getPlayerVehicle(perseguicao.suspeito))
        
        -- Cria NPCs atiradores
        for i = 1, 2 do
            local ped = createPed(280, x + (i * 2), y, z)  -- SWAT
            givePedWeapon(ped, 31, 1000)  -- M4
            
            -- AI para atirar no suspeito
            -- Implementar AI
        end
    end,
    
    spawnarVeiculosEspeciais = function(self, perseguicao)
        local x, y, z = getElementPosition(getPlayerVehicle(perseguicao.suspeito))
        
        -- Cria veículos especiais
        createVehicle(601, x + 10, y, z)  -- SWAT Tank
        createVehicle(427, x - 10, y, z)  -- Enforcer
    end
}
```

### 3. Sistema de Dano Realista
```lua
local DanoRealista = {
    partes = {
        motor = {
            vida = 1000,
            efeitosDano = {
                [800] = function(veiculo) -- Leve
                    setVehicleEngineState(veiculo, false)
                    setTimer(function()
                        setVehicleEngineState(veiculo, true)
                    end, 2000, 1)
                end,
                [500] = function(veiculo) -- Médio
                    local vel = {getElementVelocity(veiculo)}
                    setElementVelocity(veiculo, vel[1] * 0.5, vel[2] * 0.5, vel[3])
                end,
                [200] = function(veiculo) -- Grave
                    setVehicleEngineState(veiculo, false)
                    createFire(getElementPosition(veiculo))
                end
            }
        },
        pneus = {
            vida = 1000,
            efeitosDano = {
                [800] = function(veiculo, lado) -- Leve
                    setVehicleWheelStates(veiculo, lado, 1)
                end,
                [500] = function(veiculo, lado) -- Médio
                    setVehicleWheelStates(veiculo, lado, 2)
                end,
                [200] = function(veiculo, lado) -- Grave
                    setVehicleWheelStates(veiculo, lado, 3)
                end
            }
        },
        tanque = {
            vida = 1000,
            efeitosDano = {
                [800] = function(veiculo) -- Leve
                    setElementData(veiculo, "combustivel",
                        getElementData(veiculo, "combustivel") * 0.9)
                end,
                [500] = function(veiculo) -- Médio
                    createFire(getElementPosition(veiculo))
                end,
                [200] = function(veiculo) -- Grave
                    blowVehicle(veiculo)
                end
            }
        }
    },
    
    init = function(self, veiculo)
        -- Inicializa estado das partes
        setElementData(veiculo, "partes", {
            motor = self.partes.motor.vida,
            pneus = {
                [0] = self.partes.pneus.vida,
                [1] = self.partes.pneus.vida,
                [2] = self.partes.pneus.vida,
                [3] = self.partes.pneus.vida
            },
            tanque = self.partes.tanque.vida
        })
        
        -- Adiciona handler de dano
        addEventHandler("onVehicleDamage", veiculo,
            function(loss)
                self:processarDano(source, loss)
            end
        )
    end,
    
    processarDano = function(self, veiculo, dano)
        local partes = getElementData(veiculo, "partes")
        if not partes then return end
        
        -- Determina parte atingida
        local parteAtingida = self:determinarParteAtingida(veiculo)
        
        -- Aplica dano à parte
        if parteAtingida == "motor" then
            partes.motor = math.max(0, partes.motor - dano)
            self:aplicarEfeitosParte(veiculo, "motor", partes.motor)
        elseif parteAtingida == "pneus" then
            local pneu = math.random(0, 3)
            partes.pneus[pneu] = math.max(0, partes.pneus[pneu] - dano)
            self:aplicarEfeitosParte(veiculo, "pneus", partes.pneus[pneu], pneu)
        elseif parteAtingida == "tanque" then
            partes.tanque = math.max(0, partes.tanque - dano)
            self:aplicarEfeitosParte(veiculo, "tanque", partes.tanque)
        end
        
        -- Salva estado
        setElementData(veiculo, "partes", partes)
    end,
    
    determinarParteAtingida = function(self, veiculo)
        local x, y, z = getElementPosition(veiculo)
        local rx, ry, rz = getElementRotation(veiculo)
        
        -- Implementar lógica de detecção de colisão por parte
        -- Por enquanto, retorna aleatório
        local partes = {"motor", "pneus", "tanque"}
        return partes[math.random(#partes)]
    end,
    
    aplicarEfeitosParte = function(self, veiculo, parte, vida, ...)
        local efeitosDano = self.partes[parte].efeitosDano
        
        -- Aplica efeitos baseados na vida
        for limiar, efeito in pairs(efeitosDano) do
            if vida <= limiar then
                efeito(veiculo, ...)
                break
            end
        end
    end
}
```

## Dicas e Boas Práticas

1. **Otimização de Performance**
```lua
-- Use timers eficientemente
local function atualizarVeiculos()
    for _, veiculo in ipairs(getElementsByType("vehicle")) do
        -- Atualize todos os veículos de uma vez
    end
end
setTimer(atualizarVeiculos, 1000, 0)

-- Cache de funções
local getElementPosition = getElementPosition
local setElementPosition = setElementPosition
```

2. **Sincronização Cliente-Servidor**
```lua
-- Eventos síncronos
addEvent("onVehicleCustom", true)
addEventHandler("onVehicleCustom", root,
    function(dados)
        if client ~= source then return end
        -- Processa dados
    end
)

-- Notificações
function notificarJogadores(veiculo, mensagem)
    local ocupantes = getVehicleOccupants(veiculo)
    for _, player in pairs(ocupantes) do
        outputChatBox(mensagem, player)
    end
end
```

3. **Gerenciamento de Recursos**
```lua
-- Limpe elementos não utilizados
function limparVeiculo(veiculo)
    -- Remove blips
    local blips = getAttachedElements(veiculo)
    for _, blip in ipairs(blips) do
        if getElementType(blip) == "blip" then
            destroyElement(blip)
        end
    end
    
    -- Remove timers
    if isTimer(getElementData(veiculo, "updateTimer")) then
        killTimer(getElementData(veiculo, "updateTimer"))
    end
end

-- Remova handlers
function removerHandlers(veiculo)
    removeEventHandler("onVehicleDamage", veiculo, onDamage)
    removeEventHandler("onVehicleEnter", veiculo, onEnter)
end
```

4. **Debug e Logging**
```lua
function logVeiculo(veiculo, acao, dados)
    if not settings.debug then return end
    
    local modelo = getVehicleName(veiculo)
    local pos = {getElementPosition(veiculo)}
    
    outputDebugString(string.format("[Veículo] %s - Ação: %s, Dados: %s, Pos: %.2f,%.2f,%.2f",
        modelo,
        acao,
        inspect(dados),
        unpack(pos)
    ))
end
```
