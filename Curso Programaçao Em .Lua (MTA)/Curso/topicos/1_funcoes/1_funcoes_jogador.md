# Funções de Jogador no MTA:SA

## Níveis de Conhecimento

### 1. Iniciante
#### O que são funções de jogador?
São comandos que permitem manipular jogadores no servidor. Você pode:
- Mudar a posição do jogador
- Alterar sua vida
- Dar ou tirar dinheiro
- Mudar seu nome
- E muito mais!

#### Funções Básicas
```lua
-- Spawnar um jogador
spawnPlayer(player, x, y, z)  -- Coloca o jogador em uma posição

-- Vida e Colete
setElementHealth(player, 100)  -- Define vida (0-100)
setPedArmor(player, 100)      -- Define colete (0-100)

-- Dinheiro
setPlayerMoney(player, 1000)   -- Define dinheiro
givePlayerMoney(player, 500)   -- Adiciona dinheiro
takePlayerMoney(player, 200)   -- Remove dinheiro
```

### 2. Intermediário
#### Manipulação Avançada
```lua
-- Posição e Rotação
local x, y, z = getElementPosition(player)  -- Obtém posição
setElementPosition(player, x + 5, y, z)     -- Move 5 unidades em X

local rx, ry, rz = getElementRotation(player)  -- Obtém rotação
setElementRotation(player, rx, ry, rz + 90)    -- Gira 90 graus

-- Estados do Jogador
setPedAnimation(player, "ped", "walk_player")  -- Define animação
setElementFrozen(player, true)                 -- Congela jogador
toggleAllControls(player, false)               -- Desativa controles
```

### 3. Avançado
#### Sistema de Stats
```lua
-- Habilidades
setPedStat(player, 22, 1000)  -- Define skill de arma
getPedStat(player, 22)        -- Obtém skill

-- Sistema de Fome/Sede
local function gerenciarNecessidades(player)
    local fome = getElementData(player, "fome") or 100
    local sede = getElementData(player, "sede") or 100
    
    -- Diminui necessidades
    fome = math.max(0, fome - 1)
    sede = math.max(0, sede - 2)
    
    -- Aplica efeitos
    if fome < 20 or sede < 20 then
        setElementHealth(player, getElementHealth(player) - 1)
    end
    
    -- Salva dados
    setElementData(player, "fome", fome)
    setElementData(player, "sede", sede)
end
```

### 4. Expert
#### Sistema Completo de Jogador
```lua
local PlayerManager = {
    jogadores = {},
    
    -- Inicialização
    init = function(self, player)
        self.jogadores[player] = {
            stats = {
                nivel = 1,
                xp = 0,
                fome = 100,
                sede = 100,
                stamina = 100
            },
            inventory = {},
            skills = {},
            quests = {}
        }
        
        -- Carregar dados salvos
        self:carregarDados(player)
        
        -- Iniciar sistemas
        self:iniciarTimers(player)
        self:aplicarBuffs(player)
    end,
    
    -- Sistema de Stats
    atualizarStats = function(self, player)
        local dados = self.jogadores[player]
        if not dados then return end
        
        -- Atualiza necessidades
        dados.stats.fome = math.max(0, dados.stats.fome - 0.5)
        dados.stats.sede = math.max(0, dados.stats.sede - 1)
        dados.stats.stamina = math.min(100, dados.stats.stamina + 0.2)
        
        -- Aplica efeitos
        self:aplicarEfeitosStats(player, dados.stats)
        
        -- Sincroniza com cliente
        self:sincronizarDados(player)
    end,
    
    -- Sistema de Skills
    aumentarSkill = function(self, player, skill, quantidade)
        local dados = self.jogadores[player]
        if not dados then return end
        
        -- Aumenta skill
        dados.skills[skill] = (dados.skills[skill] or 0) + quantidade
        
        -- Verifica level up
        self:verificarLevelUp(player, skill)
        
        -- Aplica bônus
        self:aplicarBonusSkill(player, skill)
    end,
    
    -- Sistema de Inventário
    adicionarItem = function(self, player, item, quantidade)
        local dados = self.jogadores[player]
        if not dados then return false end
        
        -- Verifica peso
        if not self:verificarPesoInventario(player, item, quantidade) then
            return false, "Inventário cheio!"
        end
        
        -- Adiciona item
        dados.inventory[item] = (dados.inventory[item] or 0) + quantidade
        
        -- Atualiza interface
        triggerClientEvent(player, "atualizarInventario", player, dados.inventory)
        
        return true
    end,
    
    -- Sistema de Quests
    iniciarQuest = function(self, player, questId)
        local dados = self.jogadores[player]
        if not dados then return false end
        
        -- Verifica requisitos
        if not self:verificarRequisitosQuest(player, questId) then
            return false, "Requisitos não atendidos!"
        end
        
        -- Inicia quest
        dados.quests[questId] = {
            progresso = 0,
            iniciada = getTickCount(),
            objetivos = {}
        }
        
        -- Inicia eventos da quest
        self:iniciarEventosQuest(player, questId)
        
        return true
    end
}

-- Exemplo de uso
addEventHandler("onPlayerJoin", root,
    function()
        PlayerManager:init(source)
    end
)
```

## Exemplos Práticos

### 1. Sistema de Spawn Personalizado
```lua
local spawns = {
    {x = 0, y = 0, z = 3, skin = 101},
    {x = 10, y = 0, z = 3, skin = 102},
    -- Adicione mais spawns
}

function spawnJogador(player)
    -- Escolhe spawn aleatório
    local spawn = spawns[math.random(#spawns)]
    
    -- Define skin e spawna
    setElementModel(player, spawn.skin)
    spawnPlayer(player, spawn.x, spawn.y, spawn.z)
    
    -- Dá itens iniciais
    giveWeapon(player, 22, 100)  -- Pistola com 100 balas
    setPlayerMoney(player, 1000)  -- Dinheiro inicial
end
```

### 2. Sistema de Vida Regenerativa
```lua
function iniciarRegeneracao(player)
    setTimer(function()
        if isElement(player) then
            local vida = getElementHealth(player)
            if vida < 100 then
                setElementHealth(player, math.min(100, vida + 1))
            end
        end
    end, 1000, 0)  -- Regenera 1 de vida por segundo
end
```

### 3. Sistema de Fome/Sede Avançado
```lua
local function gerenciarNecessidades(player)
    -- Obtém dados atuais
    local fome = getElementData(player, "fome") or 100
    local sede = getElementData(player, "sede") or 100
    
    -- Diminui baseado na atividade
    local _, _, velocidade = getElementVelocity(player)
    local diminuicao = 1 + (velocidade * 10)
    
    fome = math.max(0, fome - diminuicao)
    sede = math.max(0, sede - (diminuicao * 1.5))
    
    -- Aplica efeitos
    if fome < 20 or sede < 20 then
        -- Efeitos visuais
        triggerClientEvent(player, "efeitoFomeSede", player, fome, sede)
        
        -- Diminui vida
        if fome < 10 or sede < 10 then
            setElementHealth(player, getElementHealth(player) - 1)
        end
        
        -- Diminui stamina
        setPedStat(player, 22, getPedStat(player, 22) - 1)
    end
    
    -- Salva dados
    setElementData(player, "fome", fome)
    setElementData(player, "sede", sede)
end
```

## Dicas e Boas Práticas

1. **Cache de Funções**
```lua
local getElementHealth = getElementHealth
local setElementHealth = setElementHealth
-- Melhora performance em loops
```

2. **Verificações de Segurança**
```lua
function darVida(player, quantidade)
    if not isElement(player) then return false end
    if getElementType(player) ~= "player" then return false end
    
    quantidade = tonumber(quantidade)
    if not quantidade then return false end
    
    setElementHealth(player, math.min(100, quantidade))
    return true
end
```

3. **Otimização de Timers**
```lua
-- Ruim: Timer para cada jogador
for _, player in ipairs(getElementsByType("player")) do
    setTimer(function() end, 1000, 0)
end

-- Bom: Um timer para todos
setTimer(function()
    for _, player in ipairs(getElementsByType("player")) do
        -- código
    end
end, 1000, 0)
```

4. **Documentação**
```lua
--[[
    Função: atualizarJogador
    Descrição: Atualiza estados do jogador
    Parâmetros:
        - player: elemento do jogador
        - dados: tabela com novos dados
    Retorno: true se sucesso, false se erro
]]
function atualizarJogador(player, dados)
    -- código
end
```
