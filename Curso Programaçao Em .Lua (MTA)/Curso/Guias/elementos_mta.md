# Tudo que você precisa saber sobre Elementos no MTA:SA

## O que tem aqui
1. [Funções Principais](#1-funções)
2. [Eventos do Jogo](#2-eventos)
3. [Elementos do Game](#3-elementos)
4. [Comandos Úteis](#4-comandos)
5. [Vars Especiais](#5-variáveis-especiais)
6. [Recursos Bacanas](#6-recursos-do-jogo)

## 1. Funções

### 1.1 Funções para mexer com Players
```lua
-- Coisas básicas
spawnPlayer(player, x, y, z)           -- Coloca player no mapa
setPlayerName(player, "nome")          -- Muda nome do player
getPlayerName(player)                  -- Pega nome do player
setPlayerMoney(player, quantidade)     -- Define grana do player
getPlayerMoney(player)                 -- Ve quantia grana tem

-- Vida e Colete
setElementHealth(player, vida)         -- Define vida do player
getElementHealth(player)               -- Ve quantia vida tem
setPedArmor(player, colete)           -- Coloca colete
getPedArmor(player)                    -- Ve quantia colete tem

-- Onde tá e pra onde olha
setElementPosition(player, x, y, z)    -- Move o player
getElementPosition(player)             -- Ve onde tá
setElementRotation(player, rx, ry, rz) -- Vira o player
getElementRotation(player)             -- Ve pra onde tá olhando
```

### 1.2 Funções para mexer com Carros
```lua
-- Criar e Mexer
createVehicle(id, x, y, z)            -- Cria um carro
setVehicleColor(vehicle, r, g, b)     -- Pinta o carro
getVehicleColor(vehicle)              -- Ve a cor
fixVehicle(vehicle)                   -- Conserta
blowVehicle(vehicle)                  -- Explode

-- Tunagem
addVehicleUpgrade(vehicle, upgrade)   -- Coloca peça
removeVehicleUpgrade(vehicle, upgrade) -- Tira peça
setVehiclePaintjob(vehicle, id)       -- Muda pintura

-- Como tá o carro
setVehicleEngineState(vehicle, state) -- Liga/desliga
setVehicleLocked(vehicle, state)      -- Tranca/destranca
```

### 1.3 Funções de Mundo
```lua
-- Clima e Tempo
setTime(hora, minuto)                 -- Define hora
getTime()                             -- Ve hora
setWeather(id)                        -- Define clima
getWeather()                          -- Ve clima

-- Objetos e Markers
createObject(id, x, y, z)             -- Cria objeto
createMarker(x, y, z, tipo, tamanho)  -- Cria marker
createBlip(x, y, z)                   -- Cria blip
```

## 2. Eventos

### 2.1 Eventos de Jogador
```lua
-- Conexão
onPlayerJoin                          -- Jogador conecta
onPlayerQuit                          -- Jogador desconecta
onPlayerLogin                         -- Jogador loga
onPlayerLogout                        -- Jogador desloga

-- Ações
onPlayerCommand                       -- Jogador usa comando
onPlayerChat                          -- Jogador chata
onPlayerDamage                        -- Jogador recebe dano
onPlayerWasted                        -- Jogador morre
```

### 2.2 Eventos de Veículo
```lua
-- Interação
onVehicleEnter                        -- Jogador entra
onVehicleExit                         -- Jogador sai
onVehicleStartEnter                   -- Começa a entrar
onVehicleStartExit                    -- Começa a sair

-- Estado
onVehicleDamage                       -- Veículo danificado
onVehicleExplode                      -- Veículo explode
```

### 2.3 Eventos de Recurso
```lua
onResourceStart                       -- Recurso inicia
onResourceStop                        -- Recurso para
onClientResourceStart                 -- Recurso inicia (cliente)
onClientResourceStop                  -- Recurso para (cliente)
```

## 3. Elementos

### 3.1 Tipos de Elementos
```lua
-- Jogadores
getElementsByType("player")           -- Lista jogadores
isElement(elemento)                   -- Verifica se existe
getElementType(elemento)              -- Ve tipo
getElementID(elemento)                -- Ve ID

-- Veículos
getElementsByType("vehicle")          -- Lista veículos
getElementModel(elemento)             -- Ve modelo
getElementAlpha(elemento)             -- Ve transparência
setElementAlpha(elemento, alpha)      -- Define transparência
```

### 3.2 Manipulação de Elementos
```lua
-- Dados
setElementData(elemento, chave, valor) -- Define dado
getElementData(elemento, chave)        -- Ve dado
hasElementData(elemento, chave)        -- Verifica dado

-- Dimensão e Interior
setElementDimension(elemento, dim)     -- Define dimensão
getElementDimension(elemento)          -- Ve dimensão
setElementInterior(elemento, int)      -- Define interior
getElementInterior(elemento)           -- Ve interior
```

## 4. Comandos

### 4.1 Registro de Comandos
```lua
-- Comandos de Servidor
addCommandHandler("comando", function)  -- Adiciona comando
removeCommandHandler("comando")         -- Remove comando

-- Comandos de Cliente
bindKey("tecla", "estado", function)   -- Associa tecla
unbindKey("tecla", "estado")          -- Desassocia tecla
```

### 4.2 ACL (Access Control List)
```lua
-- Verificações
hasObjectPermissionTo(objeto, direito) -- Verifica permissão
isObjectInACLGroup(objeto, grupo)      -- Verifica grupo

-- Manipulação
aclCreate(nome)                        -- Cria ACL
aclDestroy(acl)                        -- Destroi ACL
aclGroupAddObject(grupo, objeto)       -- Adiciona objeto
```

## 5. Variáveis Especiais

### 5.1 Variáveis Globais
```lua
root       -- Elemento raiz
resourceRoot -- Raiz do recurso atual
localPlayer -- Jogador local (cliente)
source     -- Elemento que triggou evento
client     -- Cliente que triggou evento
```

### 5.2 Variáveis de Estado
```lua
getTickCount()      -- Tempo desde início
getRealTime()       -- Tempo real
getVersion()        -- Versão do MTA
getNetworkStats()   -- Estatísticas de rede
```

## 6. Recursos do Jogo

### 6.1 Interface Gráfica
```lua
-- Janelas
guiCreateWindow(x, y, w, h, texto)    -- Cria janela
guiCreateButton(x, y, w, h, texto)    -- Cria botão
guiCreateEdit(x, y, w, h, texto)      -- Cria campo texto

-- DX
dxDrawText(texto, x, y)               -- Desenha texto
dxDrawRectangle(x, y, w, h)           -- Desenha retângulo
dxDrawImage(x, y, w, h, imagem)       -- Desenha imagem
```

### 6.2 Som e Efeitos
```lua
-- Som
playSound(arquivo)                     -- Toca som
playSoundFrontEnd(id)                 -- Toca som frontend
setSoundVolume(som, volume)           -- Define volume

-- Efeitos
createEffect(nome, x, y, z)           -- Cria efeito
fxAddBlood(x, y, z, dir)             -- Adiciona sangue
createExplosion(x, y, z, tipo)        -- Cria explosão
```

### 6.3 Câmera
```lua
-- Manipulação
setCameraTarget(elemento)             -- Define alvo
getCameraTarget()                     -- Ve alvo
setCameraMatrix(x, y, z, lx, ly, lz)  -- Define posição

-- Fade
fadeCamera(player, fadeIn)            -- Fade da câmera
setCameraInterior(player, interior)   -- Define interior
```

### 6.4 Colisões
```lua
-- Verificações
isElementInWater(elemento)            -- Verifica água
isElementOnGround(elemento)           -- Verifica chão
processLineOfSight(x1,y1,z1, x2,y2,z2) -- Verifica linha

-- Hitboxes
setElementCollisionsEnabled(elemento)  -- Ativa colisões
```

### 6.5 Networking
```lua
-- Cliente-Servidor
triggerServerEvent(nome, elemento)     -- Dispara evento servidor
triggerClientEvent(nome, elemento)     -- Dispara evento cliente

-- RPC
callRemote(recurso, função)           -- Chama função remota
```

## Exemplos Práticos

### Sistema de Admin
```lua
-- Verificação de Admin
function isPlayerAdmin(player)
    local account = getPlayerAccount(player)
    return isObjectInACLGroup("user." .. getAccountName(account), aclGetGroup("Admin"))
end

-- Comando de Kick
addCommandHandler("kick",
    function(player, cmd, alvo, ...)
        if not isPlayerAdmin(player) then
            return outputChatBox("Sem permissão!", player, 255, 0, 0)
        end
        
        local razao = table.concat({...}, " ")
        local targetPlayer = getPlayerFromName(alvo)
        
        if targetPlayer then
            kickPlayer(targetPlayer, player, razao)
        end
    end
)
```

### Sistema de Veículos Pessoais
```lua
local veiculosJogador = {}

-- Spawn de veículo pessoal
function spawnVeiculoPessoal(player)
    if veiculosJogador[player] then
        destroyElement(veiculosJogador[player])
    end
    
    local x, y, z = getElementPosition(player)
    local veiculo = createVehicle(411, x + 3, y, z)
    
    setElementData(veiculo, "dono", getPlayerName(player))
    veiculosJogador[player] = veiculo
end

-- Verificar dono
function isVeiculoDono(player, veiculo)
    local dono = getElementData(veiculo, "dono")
    return dono == getPlayerName(player)
end
```

### Sistema de Tempo Dinâmico
```lua
-- Variáveis de tempo
local tempoAtual = {
    hora = 12,
    minuto = 0,
    clima = 0
}

-- Atualizar tempo
function atualizarTempo()
    tempoAtual.minuto = tempoAtual.minuto + 1
    
    if tempoAtual.minuto >= 60 then
        tempoAtual.minuto = 0
        tempoAtual.hora = tempoAtual.hora + 1
        
        if tempoAtual.hora >= 24 then
            tempoAtual.hora = 0
        end
    end
    
    setTime(tempoAtual.hora, tempoAtual.minuto)
end
setTimer(atualizarTempo, 60000, 0)  -- Atualiza a cada minuto

-- Mudar clima aleatoriamente
function mudarClimaAleatorio()
    local novoClima = math.random(0, 20)
    setWeather(novoClima)
    tempoAtual.clima = novoClima
end
setTimer(mudarClimaAleatorio, 1800000, 0)  -- Muda a cada 30 minutos
