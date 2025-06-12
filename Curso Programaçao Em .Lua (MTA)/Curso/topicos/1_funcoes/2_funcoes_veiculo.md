# Funções de Veículo no MTA:SA

## Níveis de Conhecimento

### 1. Iniciante
#### O que são funções de veículo?
São comandos que permitem criar e manipular veículos no jogo. Você pode:
- Criar veículos
- Modificar cores
- Adicionar tunning
- Controlar estado do veículo
- Gerenciar combustível
- E muito mais!

#### Funções Básicas
```lua
-- Criar veículo
createVehicle(411, x, y, z)           -- Cria uma Infernus
createVehicle(522, x, y, z)           -- Cria uma NRG-500

-- Cores
setVehicleColor(veiculo, 255, 0, 0)   -- Vermelho
setVehicleColor(veiculo, 0, 255, 0)   -- Verde

-- Estado
fixVehicle(veiculo)                   -- Conserta
setVehicleEngineState(veiculo, true)  -- Liga motor
setVehicleLocked(veiculo, true)       -- Tranca portas
```

### 2. Intermediário
#### Manipulação Avançada
```lua
-- Sistema de Dano
local function gerenciarDano(veiculo)
    local health = getElementHealth(veiculo)
    
    -- Efeitos baseados no dano
    if health < 400 then
        setVehicleEngineState(veiculo, false)  -- Motor falha
        createFire(x, y, z)                    -- Cria fogo
    end
end

-- Sistema de Tunning
local function aplicarTunning(veiculo, nivel)
    if nivel == 1 then
        addVehicleUpgrade(veiculo, 1008)  -- Nitro 2x
        addVehicleUpgrade(veiculo, 1010)  -- Baixar suspensão
    elseif nivel == 2 then
        addVehicleUpgrade(veiculo, 1009)  -- Nitro 5x
        addVehicleUpgrade(veiculo, 1079)  -- Rodas especiais
    end
end
```

### 3. Avançado
#### Sistema de Combustível
```lua
local VehicleFuel = {
    consumo = {
        [411] = 0.5,  -- Infernus
        [522] = 0.3,  -- NRG-500
        -- Adicione mais veículos
    },
    
    inicializar = function(self, veiculo)
        setElementData(veiculo, "combustivel", 100)
        self:iniciarConsumo(veiculo)
    end,
    
    consumir = function(self, veiculo)
        if not isElement(veiculo) then return end
        
        local combustivel = getElementData(veiculo, "combustivel") or 100
        local modelo = getElementModel(veiculo)
        local consumoBase = self.consumo[modelo] or 0.4
        
        -- Calcula consumo baseado na velocidade
        local vx, vy, vz = getElementVelocity(veiculo)
        local velocidade = math.sqrt(vx^2 + vy^2 + vz^2)
        local consumoReal = consumoBase * (1 + velocidade)
        
        -- Atualiza combustível
        combustivel = math.max(0, combustivel - consumoReal)
        setElementData(veiculo, "combustivel", combustivel)
        
        -- Verifica tanque vazio
        if combustivel <= 0 then
            setVehicleEngineState(veiculo, false)
        end
    end,
    
    abastecer = function(self, veiculo, quantidade)
        local combustivel = getElementData(veiculo, "combustivel") or 0
        setElementData(veiculo, "combustivel", math.min(100, combustivel + quantidade))
    end
}
```

### 4. Expert
#### Sistema Completo de Veículos
```lua
local VehicleManager = {
    veiculos = {},
    
    -- Configurações por modelo
    configs = {
        [411] = {  -- Infernus
            preco = 150000,
            consumo = 0.5,
            seguro = 5000,
            manutencao = 1000,
            upgrades = {
                permitidos = {1008, 1009, 1010},
                precos = {
                    [1008] = 10000,  -- Nitro
                    [1009] = 15000,  -- Nitro 2
                    [1010] = 5000    -- Suspensão
                }
            }
        },
        -- Adicione mais modelos
    },
    
    -- Inicialização
    init = function(self, veiculo, dono)
        if not isElement(veiculo) then return false end
        
        local modelo = getElementModel(veiculo)
        
        self.veiculos[veiculo] = {
            dono = dono,
            modelo = modelo,
            quilometragem = 0,
            combustivel = 100,
            dano = 1000,
            upgrades = {},
            manutencao = {
                ultima = getTickCount(),
                proximaEm = 1000  -- km
            },
            seguro = {
                ativo = false,
                validade = 0
            }
        }
        
        -- Inicia sistemas
        self:iniciarSistemas(veiculo)
        
        return true
    end,
    
    -- Sistema de Quilometragem
    atualizarQuilometragem = function(self, veiculo)
        local dados = self.veiculos[veiculo]
        if not dados then return end
        
        local x, y, z = getElementPosition(veiculo)
        if not dados.ultimaPosicao then
            dados.ultimaPosicao = {x, y, z}
            return
        end
        
        -- Calcula distância
        local dx = x - dados.ultimaPosicao[1]
        local dy = y - dados.ultimaPosicao[2]
        local dz = z - dados.ultimaPosicao[3]
        local distancia = math.sqrt(dx^2 + dy^2 + dz^2)
        
        -- Atualiza quilometragem
        dados.quilometragem = dados.quilometragem + distancia
        dados.ultimaPosicao = {x, y, z}
        
        -- Verifica manutenção
        self:verificarManutencao(veiculo)
    end,
    
    -- Sistema de Manutenção
    verificarManutencao = function(self, veiculo)
        local dados = self.veiculos[veiculo]
        if not dados then return end
        
        if dados.quilometragem >= dados.manutencao.proximaEm then
            -- Aplica penalidades
            local dano = getElementHealth(veiculo)
            setElementHealth(veiculo, math.max(300, dano - 1))
            
            -- Notifica dono
            local dono = dados.dono
            if isElement(dono) then
                outputChatBox("Seu veículo precisa de manutenção!", dono, 255, 0, 0)
            end
        end
    end,
    
    -- Sistema de Seguro
    ativarSeguro = function(self, veiculo)
        local dados = self.veiculos[veiculo]
        if not dados then return false end
        
        local config = self.configs[dados.modelo]
        if not config then return false end
        
        -- Verifica se dono pode pagar
        local dono = dados.dono
        if not isElement(dono) then return false end
        
        if getPlayerMoney(dono) < config.seguro then
            return false, "Dinheiro insuficiente"
        end
        
        -- Ativa seguro
        takePlayerMoney(dono, config.seguro)
        dados.seguro.ativo = true
        dados.seguro.validade = getTickCount() + (7 * 24 * 60 * 60 * 1000)  -- 7 dias
        
        return true
    end,
    
    -- Sistema de Tunning
    aplicarUpgrade = function(self, veiculo, upgrade)
        local dados = self.veiculos[veiculo]
        if not dados then return false end
        
        local config = self.configs[dados.modelo]
        if not config then return false end
        
        -- Verifica se upgrade é permitido
        if not table.find(config.upgrades.permitidos, upgrade) then
            return false, "Upgrade não permitido"
        end
        
        -- Verifica preço
        local preco = config.upgrades.precos[upgrade]
        local dono = dados.dono
        if not isElement(dono) or getPlayerMoney(dono) < preco then
            return false, "Dinheiro insuficiente"
        end
        
        -- Aplica upgrade
        if addVehicleUpgrade(veiculo, upgrade) then
            takePlayerMoney(dono, preco)
            table.insert(dados.upgrades, upgrade)
            return true
        end
        
        return false
    end,
    
    -- Sistema de Salvamento
    salvarDados = function(self, veiculo)
        local dados = self.veiculos[veiculo]
        if not dados then return false end
        
        -- Prepara dados para salvar
        local dadosSalvar = {
            modelo = dados.modelo,
            quilometragem = dados.quilometragem,
            upgrades = dados.upgrades,
            posicao = {getElementPosition(veiculo)},
            rotacao = {getElementRotation(veiculo)},
            dano = getElementHealth(veiculo)
        }
        
        -- Salva em XML ou banco de dados
        -- Implementar sistema de salvamento
        
        return true
    end
}

-- Eventos
addEventHandler("onVehicleEnter", root,
    function(player, seat)
        if seat == 0 then  -- Motorista
            VehicleManager:verificarDono(source, player)
        end
    end
)

addEventHandler("onVehicleDamage", root,
    function(loss)
        VehicleManager:processarDano(source, loss)
    end
)

-- Timer para atualização constante
setTimer(function()
    for veiculo in pairs(VehicleManager.veiculos) do
        if isElement(veiculo) then
            VehicleManager:atualizarQuilometragem(veiculo)
            VehicleManager:verificarManutencao(veiculo)
        end
    end
end, 1000, 0)
```

## Exemplos Práticos

### 1. Sistema de Concessionária
```lua
local Concessionaria = {
    veiculos = {
        {modelo = 411, nome = "Infernus", preco = 150000},
        {modelo = 522, nome = "NRG-500", preco = 50000},
        -- Adicione mais veículos
    },
    
    comprarVeiculo = function(self, player, modelo)
        -- Encontra veículo
        local veiculo = self:encontrarVeiculo(modelo)
        if not veiculo then
            return false, "Veículo não encontrado"
        end
        
        -- Verifica dinheiro
        if getPlayerMoney(player) < veiculo.preco then
            return false, "Dinheiro insuficiente"
        end
        
        -- Cria veículo
        local x, y, z = getElementPosition(player)
        local novoVeiculo = createVehicle(veiculo.modelo, x + 3, y, z)
        
        -- Processa pagamento
        takePlayerMoney(player, veiculo.preco)
        
        -- Inicializa sistemas
        VehicleManager:init(novoVeiculo, player)
        
        return true, "Veículo comprado com sucesso!"
    end
}
```

### 2. Sistema de Oficina
```lua
local Oficina = {
    precos = {
        reparo = 1000,
        pintura = 500,
        tunning = {
            [1008] = 10000,  -- Nitro
            [1009] = 15000,  -- Nitro 2
            [1010] = 5000    -- Suspensão
        }
    },
    
    repararVeiculo = function(self, veiculo, player)
        -- Verifica dono
        if not VehicleManager:isDono(veiculo, player) then
            return false, "Este não é seu veículo"
        end
        
        -- Calcula preço baseado no dano
        local dano = 1000 - getElementHealth(veiculo)
        local preco = math.floor(dano * (self.precos.reparo / 1000))
        
        -- Verifica dinheiro
        if getPlayerMoney(player) < preco then
            return false, "Dinheiro insuficiente"
        end
        
        -- Repara
        fixVehicle(veiculo)
        takePlayerMoney(player, preco)
        
        return true, "Veículo reparado!"
    end,
    
    pintarVeiculo = function(self, veiculo, player, r, g, b)
        -- Implementar sistema de pintura
    end,
    
    aplicarTunning = function(self, veiculo, player, upgrade)
        -- Implementar sistema de tunning
    end
}
```

## Dicas e Boas Práticas

1. **Verificações de Segurança**
```lua
-- Sempre verifique elementos
if not isElement(veiculo) then return false end
if getElementType(veiculo) ~= "vehicle" then return false end

-- Verifique propriedade
function isDono(veiculo, player)
    local dono = getElementData(veiculo, "dono")
    return dono == getPlayerName(player)
end
```

2. **Otimização**
```lua
-- Cache de funções
local getElementHealth = getElementHealth
local setElementHealth = setElementHealth

-- Cache de posições
local ultimasPosicoes = {}
function atualizarPosicao(veiculo)
    local pos = ultimasPosicoes[veiculo] or {0, 0, 0}
    local x, y, z = getElementPosition(veiculo)
    ultimasPosicoes[veiculo] = {x, y, z}
    return x - pos[1], y - pos[2], z - pos[3]
end
```

3. **Eventos Personalizados**
```lua
-- Crie eventos para ações importantes
addEvent("onVehicleFuelEmpty", true)
addEvent("onVehicleNeedMaintenance", true)

-- Use-os para notificar clientes
addEventHandler("onVehicleFuelEmpty", root,
    function(veiculo)
        local ocupantes = getVehicleOccupants(veiculo)
        for _, player in pairs(ocupantes) do
            triggerClientEvent(player, "mostrarAvisoCombustivel", player)
        end
    end
)
```

4. **Sistema de Logs**
```lua
function logVeiculo(acao, veiculo, player)
    local tempo = os.date("%Y-%m-%d %H:%M:%S")
    local modelo = getVehicleName(veiculo)
    local jogador = getPlayerName(player)
    
    outputDebugString(string.format("[%s] %s - Veículo: %s, Jogador: %s",
        tempo, acao, modelo, jogador))
end
```
