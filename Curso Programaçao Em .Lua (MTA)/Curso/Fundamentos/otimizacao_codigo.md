# Dicas pra Deixar seu Código MTA:SA mais Rápido
E aí dev! Vamo aprender sobre como otimizar seu codigo em Lua? È muito util para questoes de performance!
## O que você vai encontrar aqui
1. [O Básico](#1-o-básico)
2. [Como Melhorar suas Variáveis](#2-como-melhorar-suas-variáveis)
3. [Loops mais Eficientes](#3-loops-mais-eficientes)
4. [Tabelas Otimizadas](#4-tabelas-otimizadas)
5. [Funções que Rodam Melhor](#5-funções-que-rodam-melhor)
6. [Eventos mais Leves](#6-eventos-mais-leves)
7. [Recursos sem Peso](#7-recursos-sem-peso)
8. [Network mais Rápida](#8-network-mais-rápida)
9. [Ferramentas pra Testar Performance](#9-ferramentas-pra-testar-performance)
10. [Exemplos Práticos](#10-exemplos-práticos)

## 1. O Básico

### 1.1 Regras que Você Precisa Saber
- Sempre q der, use vars locais
- Não faça loops à toa
- Guarde resultados q vc usa muito
- Evite mandar mta coisa pela rede
- Não crie objetos sem necessidade

### 1.2 Exemplo Rápido
```lua
-- Jeito ruim
function getPlayerData()
    return getElementData(source, "data")
end

-- Jeito bom
local getElementData = getElementData
function getPlayerData()
    return getElementData(source, "data")
end
```

## 2. Como Melhorar suas Variáveis

### 2.1 Onde Declarar suas Vars
```lua
-- Não faça assim (global)
playerData = {}

-- Faça assim (local)
local playerData = {}

-- Melhor ainda (módulo organizado)
local PlayerData = {
    _cache = {},
    get = function(player) ... end,
    set = function(player, data) ... end
}
```

### 2.2 Cache de Funções
```lua
-- Cache de funções nativas
local pairs = pairs
local ipairs = ipairs
local table_insert = table.insert
local math_floor = math.floor
```

## 3. Loops mais Eficientes

### 3.1 Loops Eficientes
```lua
-- Ruim
for i = 1, #tabela do
    for j = 1, #tabela do
        -- O tamanho é calculado em cada iteração
    end
end

-- Bom
local tamanho = #tabela
for i = 1, tamanho do
    for j = 1, tamanho do
        -- Tamanho calculado uma vez só
    end
end
```

### 3.2 Break Antecipado
```lua
-- Ruim
local function encontrarJogador(nome)
    for _, player in ipairs(getElementsByType("player")) do
        if getPlayerName(player) == nome then
            return player
        end
    end
end

-- Bom
local function encontrarJogador(nome)
    local players = getElementsByType("player")
    for i = 1, #players do
        if getPlayerName(players[i]) == nome then
            return players[i]
        end
    end
end
```

## 4. Tabelas Otimizadas

### 4.1 Pré-alocação
```lua
-- Ruim
local tabela = {}
for i = 1, 1000 do
    tabela[i] = i
end

-- Bom
local tabela = table.create(1000)
for i = 1, 1000 do
    tabela[i] = i
end
```

### 4.2 Remoção Eficiente
```lua
-- Ruim (shift de elementos)
table.remove(tabela, 1)

-- Bom (para grandes tabelas)
tabela[chave] = nil
```

## 5. Funções que Rodam Melhor

### 5.1 Memoização
```lua
local cache = {}
local function calcularComplexo(valor)
    if cache[valor] then
        return cache[valor]
    end
    
    -- Cálculo complexo aqui
    local resultado = -- ... cálculo ...
    
    cache[valor] = resultado
    return resultado
end
```

### 5.2 Closures Eficientes
```lua
-- Ruim
function criarContador()
    local count = 0
    return function()
        count = count + 1
        return count
    end
end

-- Bom
local function criarContador()
    local count = 0
    local function contador()
        count = count + 1
        return count
    end
    return contador
end
```

## 6. Eventos mais Leves

### 6.1 Eventos Eficientes
```lua
-- Ruim
addEventHandler("onElementDataChange", root,
    function(dataName)
        if dataName == "score" then
            -- código
        end
    end
)

-- Bom
addEventHandler("onElementDataChange", root,
    function(dataName)
        if source:getType() ~= "player" then return end
        if dataName ~= "score" then return end
        -- código
    end
)
```

### 6.2 Debouncing
```lua
local lastUpdate = 0
local function atualizarInterface()
    local now = getTickCount()
    if now - lastUpdate < 100 then return end
    lastUpdate = now
    
    -- Atualização pesada aqui
end
```

## 7. Recursos sem Peso

### 7.1 Gerenciamento de Memória
```lua
local ResourceManager = {
    cache = {},
    
    limparCache = function(self)
        for k, v in pairs(self.cache) do
            if v.lastUsed + 300000 < getTickCount() then
                self.cache[k] = nil
            end
        end
    end,
    
    obterRecurso = function(self, id)
        if not self.cache[id] then
            self.cache[id] = {
                data = carregarRecurso(id),
                lastUsed = getTickCount()
            }
        end
        return self.cache[id].data
    end
}
```

### 7.2 Pooling de Objetos
```lua
local ObjectPool = {
    pool = {},
    
    obterObjeto = function(self)
        return table.remove(self.pool) or self:criarNovoObjeto()
    end,
    
    devolverObjeto = function(self, obj)
        if #self.pool < 100 then
            table.insert(self.pool, obj)
        end
    end
}
```

## 8. Network mais Rápida

### 8.1 Compressão de Dados
```lua
local function comprimirDados(dados)
    -- Remove dados desnecessários
    local dadosComprimidos = {
        p = dados.posicao,
        v = dados.velocidade,
        h = dados.vida
    }
    return dadosComprimidos
end

local function descomprimirDados(dadosComprimidos)
    return {
        posicao = dadosComprimidos.p,
        velocidade = dadosComprimidos.v,
        vida = dadosComprimidos.h
    }
end
```

### 8.2 Delta Compression
```lua
local lastState = {}
local function enviarAtualizacao(estado)
    local delta = {}
    for k, v in pairs(estado) do
        if lastState[k] ~= v then
            delta[k] = v
            lastState[k] = v
        end
    end
    return #delta > 0 and delta or nil
end
```

## 9. Ferramentas pra Testar Performance

### 9.1 Timer Simples
```lua
local function medirTempo(func, nome)
    local inicio = getTickCount()
    func()
    local fim = getTickCount()
    outputDebugString(nome .. ": " .. (fim - inicio) .. "ms")
end
```

### 9.2 Profiler Avançado
```lua
local Profiler = {
    tempos = {},
    
    iniciar = function(self, nome)
        self.tempos[nome] = {
            inicio = getTickCount(),
            chamadas = (self.tempos[nome] and self.tempos[nome].chamadas or 0) + 1
        }
    end,
    
    parar = function(self, nome)
        local tempo = self.tempos[nome]
        if tempo then
            local duracao = getTickCount() - tempo.inicio
            tempo.total = (tempo.total or 0) + duracao
            tempo.media = tempo.total / tempo.chamadas
        end
    end,
    
    relatorio = function(self)
        for nome, dados in pairs(self.tempos) do
            outputDebugString(string.format("%s: %dms (média: %dms, chamadas: %d)",
                nome, dados.total, dados.media, dados.chamadas))
        end
    end
}
```

## 10. Exemplos Práticos

### 10.1 Sistema de Colisão Otimizado
```lua
local CollisionSystem = {
    objetos = {},
    grid = {},
    tamanhoCell = 10,
    
    adicionarObjeto = function(self, obj)
        local cell = self:calcularCell(obj.x, obj.y)
        if not self.grid[cell] then
            self.grid[cell] = {}
        end
        table.insert(self.grid[cell], obj)
    end,
    
    verificarColisoes = function(self, x, y, raio)
        local cell = self:calcularCell(x, y)
        local proximosObjetos = self.grid[cell] or {}
        
        local colisoes = {}
        for _, obj in ipairs(proximosObjetos) do
            if self:distancia(x, y, obj.x, obj.y) <= raio then
                table.insert(colisoes, obj)
            end
        end
        return colisoes
    end
}
```

### 10.2 Sistema de Renderização Eficiente
```lua
local RenderSystem = {
    elementos = {},
    
    adicionarElemento = function(self, elemento)
        local distancia = getDistanceBetweenPoints3D(
            elemento.x, elemento.y, elemento.z,
            cameraX, cameraY, cameraZ
        )
        
        if distancia <= elemento.renderDistance then
            self.elementos[elemento] = true
        else
            self.elementos[elemento] = nil
        end
    end,
    
    renderizar = function(self)
        for elemento in pairs(self.elementos) do
            if isElementOnScreen(elemento) then
                -- Renderiza apenas elementos visíveis
                elemento:render()
            end
        end
    end
}
```

## Dicas Finais

1. **Sempre Profile Primeiro**
   - Identifique gargalos reais
   - Otimize apenas o necessário
   - Mantenha métricas

2. **Balanceie Memória vs CPU**
   - Cache consome memória
   - Recálculo consome CPU
   - Encontre o equilíbrio

3. **Mantenha o Código Legível**
   - Otimização não deve sacrificar legibilidade
   - Documente otimizações complexas
   - Use nomes descritivos

4. **Teste em Diferentes Cenários**
   - Poucos jogadores
   - Muitos jogadores
   - Diferentes configurações
   - Diferentes situações de jogo
