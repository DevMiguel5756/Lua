# Sistema de Corridas MTA:SA

E aí mano! Vamo criar um sistema de corridas maneiro? Aqui vai o passo a passo:

## 1. Estrutura Básica

### 1.1 Banco de Dados
Primeiro, vamo criar as tabelas:
```sql
CREATE TABLE corridas (
    id INT PRIMARY KEY,
    nome VARCHAR(50),
    tipo VARCHAR(20),
    checkpoints TEXT,
    recorde FLOAT
);

CREATE TABLE resultados (
    id INT PRIMARY KEY,
    corrida_id INT,
    player VARCHAR(50),
    tempo FLOAT,
    posicao INT,
    data TIMESTAMP
);
```

### 1.2 Funções Base
Funções principais q vamos precisar:
```lua
-- Funções da corrida
function criarCorrida(nome, checkpoints)
    -- Seu código aqui
end

function iniciarCorrida(corrida)
    -- Seu código aqui
end

function finalizarCorrida(player)
    -- Seu código aqui
end

function verificarCheckpoint(player, marker)
    -- Seu código aqui
end
```

## 2. Sistema de Corrida

### 2.1 Checkpoints
Sistema de checkpoints q:
- Cria markers em sequência
- Verifica progresso
- Mostra próximo ponto
- Calcula distâncias

```lua
-- Sistema de checkpoints
function criarCheckpoints(corrida)
    local checkpoints = {}
    
    for i, pos in ipairs(corrida.pontos) do
        local marker = createMarker(
            pos.x, pos.y, pos.z,
            "checkpoint",
            4,
            255, 0, 0, 150
        )
        table.insert(checkpoints, marker)
    end
    
    return checkpoints
end
```

### 2.2 Timer e Ranking
Add sistema q:
- Conta tempo total
- Mostra tempos parciais
- Atualiza ranking
- Guarda recordes

```lua
-- Sistema de tempo
function iniciarTimer(player)
    local timer = {
        inicio = getTickCount(),
        parciais = {},
        checkpoint = 1
    }
    
    setElementData(player, "race:timer", timer)
end
```

## 3. Features Extras

### 3.1 Tipos de Corrida
Diferentes tipos tipo:
- Sprint (A pra B)
- Circuito (voltas)
- Checkpoint (livre)
- Time trial

```lua
-- Tipos de corrida
local tipos = {
    sprint = {
        voltas = 1,
        tipo = "linear"
    },
    circuito = {
        voltas = 3,
        tipo = "loop"
    }
}
```

### 3.2 Sistema de Apostas
Add apostas com:
- Valor mínimo
- Odds dinâmicas
- Split do prêmio
- Ranking de grana

```lua
-- Sistema de apostas
function criarAposta(player, valor, corredor)
    if valor < apostaMinima then return false end
    -- Processar aposta
end
```

## 4. Interface

### 4.1 HUD da Corrida
Mostra na tela:
- Tempo atual
- Posição
- Velocidade
- Checkpoint

```lua
-- HUD da corrida
function atualizarHUD(player)
    local timer = getElementData(player, "race:timer")
    local pos = getElementData(player, "race:position")
    
    -- Atualizar interface
end
```

### 4.2 Menu de Corridas
Interface q mostra:
- Lista de corridas
- Recordes
- Prêmios
- Rankings

```lua
-- Menu principal
function abrirMenuCorridas()
    local window = guiCreateWindow(0.3, 0.3, 0.4, 0.4, "Corridas", true)
    
    -- Lista de corridas
    local gridCorridas = guiCreateGridList(0.05, 0.1, 0.9, 0.7, true, window)
    
    -- Botões
    local btnIniciar = guiCreateButton(0.3, 0.85, 0.4, 0.1, "Iniciar", true, window)
end
```

## 5. Dicas pra Implementar

### 5.1 Planejamento
1. Comece pelo básico
2. Add features aos poucos
3. Teste bastante
4. Pegue feedback

### 5.2 Debug
1. Use prints
2. Teste colisões
3. Verifique sync
4. Corrija bugs

### 5.3 Organização
1. Comente bem
2. Separe em módulos
3. Use eventos
4. Documente tudo

## 6. Extras

### 6.1 Features Legais
- Nitro especial
- Power-ups
- Atalhos secretos
- Clima dinâmico

### 6.2 Competitivo
- Seasons
- Ligas
- Torneios
- Prêmios

## 7. Próximos Passos

Depois q terminar:
1. Teste tudo
2. Otimize
3. Add features
4. Atualize sempre

Lembra:
- Teste bastante
- Sync é importante
- Balance os tipos
- Divirta-se!

# Exercício: Sistema de Corridas

## Objetivo
Criar um sistema completo de corridas com:
- Criação de pistas
- Lobby de jogadores
- Sistema de apostas
- Ranking e recordes
- Interface gráfica completa

## Requisitos

### 1. Sistema de Pistas
```lua
local RaceSystem = {
    pistas = {},
    
    criarPista = function(self, nome, checkpoints)
        if self.pistas[nome] then
            return false
        end
        
        self.pistas[nome] = {
            nome = nome,
            checkpoints = checkpoints,
            recordes = {},
            criador = getPlayerName(source),
            dataCriacao = os.time()
        }
        
        -- Salva pista
        self:salvarPista(nome)
        
        return true
    end,
    
    carregarPistas = function(self)
        local xml = xmlLoadFile("pistas.xml")
        if not xml then return end
        
        local pistas = xmlNodeGetChildren(xml)
        for _, node in ipairs(pistas) do
            local nome = xmlNodeGetAttribute(node, "nome")
            local checkpoints = fromJSON(xmlNodeGetAttribute(node, "checkpoints"))
            local recordes = fromJSON(xmlNodeGetAttribute(node, "recordes"))
            local criador = xmlNodeGetAttribute(node, "criador")
            local dataCriacao = xmlNodeGetAttribute(node, "dataCriacao")
            
            self.pistas[nome] = {
                nome = nome,
                checkpoints = checkpoints,
                recordes = recordes,
                criador = criador,
                dataCriacao = dataCriacao
            }
        end
        
        xmlUnloadFile(xml)
    end,
    
    salvarPista = function(self, nome)
        local pista = self.pistas[nome]
        if not pista then return end
        
        local xml = xmlLoadFile("pistas.xml") or xmlCreateFile("pistas.xml", "pistas")
        
        -- Procura node existente
        local node
        local nodes = xmlNodeGetChildren(xml)
        for _, n in ipairs(nodes) do
            if xmlNodeGetAttribute(n, "nome") == nome then
                node = n
                break
            end
        end
        
        -- Cria novo node se não existir
        if not node then
            node = xmlCreateChild(xml, "pista")
        end
        
        -- Atualiza atributos
        xmlNodeSetAttribute(node, "nome", nome)
        xmlNodeSetAttribute(node, "checkpoints", toJSON(pista.checkpoints))
        xmlNodeSetAttribute(node, "recordes", toJSON(pista.recordes))
        xmlNodeSetAttribute(node, "criador", pista.criador)
        xmlNodeSetAttribute(node, "dataCriacao", pista.dataCriacao)
        
        xmlSaveFile(xml)
        xmlUnloadFile(xml)
    end,
    
    getPista = function(self, nome)
        return self.pistas[nome]
    end,
    
    getPistas = function(self)
        local lista = {}
        for nome, pista in pairs(self.pistas) do
            table.insert(lista, {
                nome = nome,
                criador = pista.criador,
                checkpoints = #pista.checkpoints,
                recordes = #pista.recordes
            })
        end
        return lista
    end
}
```

### 2. Sistema de Corridas
```lua
local RaceManager = {
    corridas = {},
    
    criarCorrida = function(self, nome, pista)
        if self.corridas[nome] then
            return false
        end
        
        self.corridas[nome] = {
            nome = nome,
            pista = pista,
            estado = "aguardando",
            jogadores = {},
            apostas = {},
            tempoInicio = 0,
            tempos = {}
        }
        
        return true
    end,
    
    entrarCorrida = function(self, player, nome)
        local corrida = self.corridas[nome]
        if not corrida then return false end
        
        if corrida.estado ~= "aguardando" then
            return false
        end
        
        corrida.jogadores[player] = {
            checkpoint = 0,
            tempo = 0,
            veiculo = nil
        }
        
        return true
    end,
    
    iniciarCorrida = function(self, nome)
        local corrida = self.corridas[nome]
        if not corrida then return false end
        
        if corrida.estado ~= "aguardando" then
            return false
        end
        
        -- Prepara jogadores
        for player, dados in pairs(corrida.jogadores) do
            -- Cria veículo
            local x, y, z = unpack(corrida.pista.checkpoints[1])
            dados.veiculo = createVehicle(411, x, y, z)
            warpPedIntoVehicle(player, dados.veiculo)
            
            -- Reseta estado
            dados.checkpoint = 0
            dados.tempo = 0
        end
        
        -- Inicia contagem
        corrida.estado = "contagem"
        corrida.tempoInicio = getTickCount()
        
        setTimer(function()
            corrida.estado = "rodando"
            
            -- Notifica jogadores
            for player in pairs(corrida.jogadores) do
                triggerClientEvent(player, "onRaceStart", player)
            end
        end, 3000, 1)
        
        return true
    end,
    
    checkpointAtingido = function(self, player, nome, checkpoint)
        local corrida = self.corridas[nome]
        if not corrida then return end
        
        local dados = corrida.jogadores[player]
        if not dados then return end
        
        -- Verifica sequência
        if checkpoint ~= dados.checkpoint + 1 then
            return
        end
        
        dados.checkpoint = checkpoint
        dados.tempo = getTickCount() - corrida.tempoInicio
        
        -- Verifica fim
        if checkpoint == #corrida.pista.checkpoints then
            self:jogadorTerminou(player, nome)
        end
    end,
    
    jogadorTerminou = function(self, player, nome)
        local corrida = self.corridas[nome]
        if not corrida then return end
        
        local dados = corrida.jogadores[player]
        if not dados then return end
        
        -- Registra tempo
        table.insert(corrida.tempos, {
            player = player,
            tempo = dados.tempo
        })
        
        -- Verifica recordes
        local pista = RaceSystem:getPista(corrida.pista.nome)
        if pista then
            table.insert(pista.recordes, {
                player = getPlayerName(player),
                tempo = dados.tempo,
                data = os.time()
            })
            
            -- Ordena recordes
            table.sort(pista.recordes, function(a, b)
                return a.tempo < b.tempo
            end)
            
            -- Limita quantidade
            while #pista.recordes > 10 do
                table.remove(pista.recordes)
            end
            
            -- Salva pista
            RaceSystem:salvarPista(corrida.pista.nome)
        end
        
        -- Verifica fim da corrida
        if #corrida.tempos == #corrida.jogadores then
            self:finalizarCorrida(nome)
        end
    end,
    
    finalizarCorrida = function(self, nome)
        local corrida = self.corridas[nome]
        if not corrida then return end
        
        -- Ordena tempos
        table.sort(corrida.tempos, function(a, b)
            return a.tempo < b.tempo
        end)
        
        -- Distribui prêmios
        local totalApostas = 0
        for _, aposta in pairs(corrida.apostas) do
            totalApostas = totalApostas + aposta.valor
        end
        
        if totalApostas > 0 then
            local vencedor = corrida.tempos[1].player
            local premio = totalApostas
            
            for player, aposta in pairs(corrida.apostas) do
                if aposta.player == vencedor then
                    givePlayerMoney(player, premio * (aposta.valor / totalApostas))
                end
            end
        end
        
        -- Notifica jogadores
        for player in pairs(corrida.jogadores) do
            triggerClientEvent(player, "onRaceEnd", player, corrida.tempos)
        end
        
        -- Remove corrida
        self.corridas[nome] = nil
    end,
    
    apostar = function(self, player, nome, alvo, valor)
        local corrida = self.corridas[nome]
        if not corrida then return false end
        
        if corrida.estado ~= "aguardando" then
            return false
        end
        
        if not corrida.jogadores[alvo] then
            return false
        end
        
        if not takePlayerMoney(player, valor) then
            return false
        end
        
        corrida.apostas[player] = {
            player = alvo,
            valor = valor
        }
        
        return true
    end
}
```

### 3. Interface Gráfica
```lua
-- Cliente
local RaceGUI = {
    window = nil,
    
    show = function(self)
        if self.window then return end
        
        -- Cria janela
        self.window = guiCreateWindow(0.2, 0.2, 0.6, 0.6, "Corridas", true)
        
        -- Tabs
        local tabPanel = guiCreateTabPanel(0.02, 0.08, 0.96, 0.9, true, self.window)
        
        -- Tab Pistas
        local tabPistas = guiCreateTab("Pistas", tabPanel)
        self:criarTabPistas(tabPistas)
        
        -- Tab Corridas
        local tabCorridas = guiCreateTab("Corridas", tabPanel)
        self:criarTabCorridas(tabCorridas)
        
        -- Tab Recordes
        local tabRecordes = guiCreateTab("Recordes", tabPanel)
        self:criarTabRecordes(tabRecordes)
        
        -- Mostra cursor
        showCursor(true)
    end,
    
    hide = function(self)
        if not self.window then return end
        
        destroyElement(self.window)
        self.window = nil
        
        showCursor(false)
    end,
    
    criarTabPistas = function(self, tab)
        -- Lista de pistas
        local gridlist = guiCreateGridList(0.05, 0.05, 0.6, 0.9, true, tab)
        
        guiGridListAddColumn(gridlist, "Nome", 0.3)
        guiGridListAddColumn(gridlist, "Criador", 0.3)
        guiGridListAddColumn(gridlist, "Checkpoints", 0.2)
        guiGridListAddColumn(gridlist, "Recordes", 0.2)
        
        -- Botões
        local btnCriar = guiCreateButton(0.7, 0.05, 0.25, 0.1,
            "Criar Pista", true, tab)
        local btnEditar = guiCreateButton(0.7, 0.2, 0.25, 0.1,
            "Editar Pista", true, tab)
        local btnDeletar = guiCreateButton(0.7, 0.35, 0.25, 0.1,
            "Deletar Pista", true, tab)
            
        -- Atualiza lista
        triggerServerEvent("onRequestPistas", localPlayer)
        
        addEventHandler("onClientPistasUpdate", root,
            function(pistas)
                guiGridListClear(gridlist)
                
                for _, pista in ipairs(pistas) do
                    local row = guiGridListAddRow(gridlist)
                    guiGridListSetItemText(gridlist, row, 1, pista.nome, false, false)
                    guiGridListSetItemText(gridlist, row, 2, pista.criador, false, false)
                    guiGridListSetItemText(gridlist, row, 3, tostring(pista.checkpoints), false, false)
                    guiGridListSetItemText(gridlist, row, 4, tostring(pista.recordes), false, false)
                end
            end
        )
    end,
    
    criarTabCorridas = function(self, tab)
        -- Lista de corridas
        local gridlist = guiCreateGridList(0.05, 0.05, 0.6, 0.9, true, tab)
        
        guiGridListAddColumn(gridlist, "Nome", 0.3)
        guiGridListAddColumn(gridlist, "Pista", 0.3)
        guiGridListAddColumn(gridlist, "Estado", 0.2)
        guiGridListAddColumn(gridlist, "Jogadores", 0.2)
        
        -- Botões
        local btnCriar = guiCreateButton(0.7, 0.05, 0.25, 0.1,
            "Criar Corrida", true, tab)
        local btnEntrar = guiCreateButton(0.7, 0.2, 0.25, 0.1,
            "Entrar", true, tab)
        local btnApostar = guiCreateButton(0.7, 0.35, 0.25, 0.1,
            "Apostar", true, tab)
            
        -- Atualiza lista
        triggerServerEvent("onRequestCorridas", localPlayer)
        
        addEventHandler("onClientCorridasUpdate", root,
            function(corridas)
                guiGridListClear(gridlist)
                
                for _, corrida in ipairs(corridas) do
                    local row = guiGridListAddRow(gridlist)
                    guiGridListSetItemText(gridlist, row, 1, corrida.nome, false, false)
                    guiGridListSetItemText(gridlist, row, 2, corrida.pista, false, false)
                    guiGridListSetItemText(gridlist, row, 3, corrida.estado, false, false)
                    guiGridListSetItemText(gridlist, row, 4, tostring(corrida.jogadores), false, false)
                end
            end
        )
    end,
    
    criarTabRecordes = function(self, tab)
        -- Lista de recordes
        local gridlist = guiCreateGridList(0.05, 0.05, 0.9, 0.9, true, tab)
        
        guiGridListAddColumn(gridlist, "Pista", 0.3)
        guiGridListAddColumn(gridlist, "Jogador", 0.3)
        guiGridListAddColumn(gridlist, "Tempo", 0.2)
        guiGridListAddColumn(gridlist, "Data", 0.2)
        
        -- Atualiza lista
        triggerServerEvent("onRequestRecordes", localPlayer)
        
        addEventHandler("onClientRecordesUpdate", root,
            function(recordes)
                guiGridListClear(gridlist)
                
                for _, recorde in ipairs(recordes) do
                    local row = guiGridListAddRow(gridlist)
                    guiGridListSetItemText(gridlist, row, 1, recorde.pista, false, false)
                    guiGridListSetItemText(gridlist, row, 2, recorde.player, false, false)
                    guiGridListSetItemText(gridlist, row, 3, 
                        string.format("%.2f", recorde.tempo / 1000), false, false)
                    guiGridListSetItemText(gridlist, row, 4, 
                        os.date("%d/%m/%Y", recorde.data), false, false)
                end
            end
        )
    end
}

-- Bind para abrir/fechar
bindKey("F7", "down",
    function()
        if RaceGUI.window then
            RaceGUI:hide()
        else
            RaceGUI:show()
        end
    end
)

-- Render de corrida
addEventHandler("onClientRender", root,
    function()
        if not isElement(localPlayer) then return end
        
        local veiculo = getPedOccupiedVehicle(localPlayer)
        if not veiculo then return end
        
        -- Render de checkpoint atual
        local corrida = RaceManager.corridas[getCorrida(localPlayer)]
        if not corrida then return end
        
        local dados = corrida.jogadores[localPlayer]
        if not dados then return end
        
        local checkpoint = corrida.pista.checkpoints[dados.checkpoint + 1]
        if not checkpoint then return end
        
        -- Desenha marker
        local x, y, z = unpack(checkpoint)
        dxDrawLine3D(x, y, z - 2, x, y, z + 2, tocolor(255, 0, 0, 200), 2)
        
        -- Desenha tempo
        local tempo = getTickCount() - corrida.tempoInicio
        dxDrawText(string.format("Tempo: %.2f", tempo / 1000),
            10, 10, nil, nil, tocolor(255, 255, 255, 255),
            1.5, "default-bold")
    end
)
```

## Desafios Extras

1. Adicione diferentes tipos de corrida:
   - Checkpoint
   - Drift
   - Drag
   - Time Trial

2. Implemente um sistema de ligas com:
   - Divisões
   - Pontuação
   - Promoção/Rebaixamento

3. Crie um sistema de tunagem para corridas:
   - Peças específicas
   - Balanceamento
   - Restrições por corrida

4. Adicione um sistema de equipes com:
   - Garagem compartilhada
   - Pontuação por equipe
   - Eventos especiais

## Dicas

1. Use colisões para detectar checkpoints

2. Implemente anti-cheat básico

3. Adicione efeitos visuais e sonoros

4. Crie um sistema de replays

## Avaliação

Seu sistema será avaliado nos seguintes aspectos:

1. Funcionalidade
   - Sistema de pistas funcional
   - Corridas fluidas
   - Apostas funcionando

2. Interface
   - GUI intuitiva
   - HUD durante corridas
   - Feedback claro

3. Código
   - Bem organizado
   - Otimizado
   - Anti-cheat

4. Extras
   - Tipos de corrida
   - Sistema de ligas
   - Replays
