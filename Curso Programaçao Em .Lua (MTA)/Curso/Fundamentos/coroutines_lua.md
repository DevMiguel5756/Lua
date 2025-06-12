# Coroutines em Lua

Vamos aprender sobre coroutines em Lua? São funções especiais que podem pausar e continuar sua execução.

## O que são Coroutines?

São funções que podem:
- Pausar sua execução
- Salvar seu estado
- Continuar depois
- Trocar dados enquanto roda

## Criando Coroutines

### 1. Função Básica
```lua
local function contar()
    for i = 1, 5 do
        print(i)
        coroutine.yield()  -- pausa aqui
    end
end

-- Cria coroutine
local co = coroutine.create(contar)

-- Roda
coroutine.resume(co)  -- 1
coroutine.resume(co)  -- 2
coroutine.resume(co)  -- 3
```

### 2. Com Valores
```lua
local function geraNumeros()
    local n = 0
    while true do
        n = n + 1
        coroutine.yield(n)  -- retorna n
    end
end

local co = coroutine.create(geraNumeros)
local ok, valor = coroutine.resume(co)  -- valor = 1
ok, valor = coroutine.resume(co)        -- valor = 2
```

## Funções de Coroutine

### 1. create()
```lua
-- Cria nova coroutine
local co = coroutine.create(function()
    print("Dentro da coroutine")
    coroutine.yield()
    print("Continuando...")
end)
```

### 2. resume()
```lua
-- Continua execução
local ok, resultado = coroutine.resume(co)
if not ok then
    print("Erro:", resultado)
end
```

### 3. yield()
```lua
-- Pausa execução
local function processo()
    print("Parte 1")
    coroutine.yield()
    print("Parte 2")
end
```

### 4. status()
```lua
-- Checa estado
local estado = coroutine.status(co)
-- "running", "suspended", "dead"
```

## Exemplos Práticos

### 1. Animação Suave
```lua
function moverSuave(objeto, x2, y2, z2, velocidade)
    -- Pega posição inicial
    local x1, y1, z1 = getElementPosition(objeto)
    
    -- Calcula distância
    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1
    local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
    
    -- Normaliza direção
    dx = dx/dist
    dy = dy/dist
    dz = dz/dist
    
    -- Cria coroutine
    return coroutine.create(function()
        local distPercorrida = 0
        
        while distPercorrida < dist do
            -- Move um passo
            local passo = math.min(velocidade, dist - distPercorrida)
            local nx = x1 + dx * distPercorrida
            local ny = y1 + dy * distPercorrida
            local nz = z1 + dz * distPercorrida
            
            setElementPosition(objeto, nx, ny, nz)
            distPercorrida = distPercorrida + passo
            
            coroutine.yield()
        end
        
        -- Garante posição final
        setElementPosition(objeto, x2, y2, z2)
    end)
end

-- Uso
local co = moverSuave(player, 100, 200, 10, 1)
local timer = setTimer(function()
    if coroutine.status(co) ~= "dead" then
        coroutine.resume(co)
    end
end, 50, 0)
```

### 2. Carregamento em Partes
```lua
function carregaMapa()
    return coroutine.create(function()
        -- Carrega terreno
        print("Carregando terreno...")
        carregaTerreno()
        coroutine.yield()
        
        -- Carrega objetos
        print("Carregando objetos...")
        for i = 1, 100 do
            criaObjeto(i)
            if i % 10 == 0 then
                coroutine.yield()
            end
        end
        
        -- Carrega NPCs
        print("Carregando NPCs...")
        for i = 1, 50 do
            criaNPC(i)
            if i % 5 == 0 then
                coroutine.yield()
            end
        end
        
        print("Mapa carregado!")
    end)
end

-- Uso
local co = carregaMapa()
local timer = setTimer(function()
    if coroutine.status(co) ~= "dead" then
        coroutine.resume(co)
    else
        killTimer(timer)
    end
end, 100, 0)
```

### 3. Processamento em Lotes
```lua
function processaJogadores(jogadores, tamLote)
    return coroutine.create(function()
        for i = 1, #jogadores, tamLote do
            -- Pega lote atual
            local fim = math.min(i + tamLote - 1, #jogadores)
            
            -- Processa lote
            for j = i, fim do
                local player = jogadores[j]
                atualizaStats(player)
                salvaDados(player)
            end
            
            -- Pausa entre lotes
            coroutine.yield()
        end
    end)
end

-- Uso
local players = getElementsByType("player")
local co = processaJogadores(players, 5)
local timer = setTimer(function()
    if coroutine.status(co) ~= "dead" then
        coroutine.resume(co)
    else
        killTimer(timer)
    end
end, 200, 0)
```

## Dicas Importantes

### 1. Tratamento de Erros
```lua
-- Sempre checa retorno do resume
local ok, erro = coroutine.resume(co)
if not ok then
    print("Erro na coroutine:", erro)
end

-- Wrap pra mais segurança
local function resumeSafe(co)
    local ok, erro = coroutine.resume(co)
    if not ok then
        outputDebugString("Erro: " .. tostring(erro))
        return false
    end
    return true
end
```

### 2. Limpeza
```lua
-- Guarda referências
local coroutines = {}

-- Adiciona
function addCoroutine(co)
    table.insert(coroutines, co)
end

-- Remove mortas
function limpaMortas()
    for i = #coroutines, 1, -1 do
        if coroutine.status(coroutines[i]) == "dead" then
            table.remove(coroutines, i)
        end
    end
end
```

### 3. Debug
```lua
-- Helper pra debug
function debugCoroutine(co)
    local status = coroutine.status(co)
    local info = debug.getinfo(co)
    
    print("Status:", status)
    print("Linha:", info.currentline)
    print("Função:", info.name)
end
```

## Conclusão

Coroutines são importantes porque:
- Dividem tarefas grandes
- Evitam travamentos
- Controlam fluxo
- Economizam recursos

Lembra:
- Use pra tarefas longas
- Trate erros sempre
- Limpe coroutines mortas
- Código limpo é código feliz!
