# Vetores em Lua

E aí dev! Vamo aprender sobre vetores em Lua? São super úteis pra trabalhar com posições e direções no MTA!

## O que são Vetores?

Vetores são valores que têm direção e magnitude. No MTA, a gente usa muito pra:
- Posições (x, y, z)
- Rotações (rx, ry, rz)
- Velocidades
- Direções

## Criando Vetores

### 1. Posições
```lua
-- Coordenadas simples
local x, y, z = 100, 200, 300

-- Como tabela
local posicao = {
    x = 100,
    y = 200,
    z = 300
}

-- Array
local coords = {100, 200, 300}
```

### 2. Rotações
```lua
-- Ângulos em graus
local rx, ry, rz = 0, 90, 180

-- Como tabela
local rotacao = {
    x = 0,
    y = 90,
    z = 180
}
```

## Operações com Vetores

### 1. Soma e Subtração
```lua
-- Soma coordenadas
local x1, y1, z1 = 100, 200, 300
local x2, y2, z2 = 50, 50, 50

local x = x1 + x2
local y = y1 + y2
local z = z1 + z2

-- Subtração
local dx = x2 - x1
local dy = y2 - y1
local dz = z2 - z1
```

### 2. Multiplicação por Escalar
```lua
-- Dobra o tamanho
local x, y, z = 100, 200, 300
local escala = 2

local nx = x * escala
local ny = y * escala
local nz = z * escala
```

### 3. Distância
```lua
-- Entre dois pontos
function getDistancia(x1, y1, z1, x2, y2, z2)
    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

-- Versão 2D (só x e y)
function getDistancia2D(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx*dx + dy*dy)
end
```

### 4. Normalização
```lua
-- Vetor unitário (tamanho 1)
function normalizar(x, y, z)
    local comprimento = math.sqrt(x*x + y*y + z*z)
    
    if comprimento == 0 then
        return 0, 0, 0
    end
    
    return x/comprimento, y/comprimento, z/comprimento
end
```

## Exemplos Práticos

### 1. Movimento Suave
```lua
-- Move objeto suavemente
function moverObjeto(objeto, xAlvo, yAlvo, zAlvo, velocidade)
    -- Pega posição atual
    local x, y, z = getElementPosition(objeto)
    
    -- Calcula direção
    local dx = xAlvo - x
    local dy = yAlvo - y
    local dz = zAlvo - z
    
    -- Normaliza e aplica velocidade
    local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
    if dist > 0 then
        dx = dx/dist * velocidade
        dy = dy/dist * velocidade
        dz = dz/dist * velocidade
    end
    
    -- Move
    setElementPosition(objeto, 
        x + dx,
        y + dy,
        z + dz
    )
    
    -- Retorna se chegou
    return dist < 1
end
```

### 2. Sistema de Colisão
```lua
-- Detecta colisão entre esferas
function testaColisao(x1, y1, z1, r1, x2, y2, z2, r2)
    -- Calcula distância
    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1
    local distancia = math.sqrt(dx*dx + dy*dy + dz*dz)
    
    -- Soma dos raios
    local somaRaios = r1 + r2
    
    -- Tem colisão se distância < soma dos raios
    return distancia < somaRaios
end

-- Resolve colisão
function resolveColisao(obj1, obj2)
    -- Pega posições
    local x1, y1, z1 = getElementPosition(obj1)
    local x2, y2, z2 = getElementPosition(obj2)
    
    -- Calcula normal da colisão
    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1
    local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
    
    if dist > 0 then
        dx = dx/dist
        dy = dy/dist
        dz = dz/dist
    end
    
    -- Aplica impulso
    local impulso = 10
    setElementVelocity(obj1, -dx*impulso, -dy*impulso, -dz*impulso)
    setElementVelocity(obj2, dx*impulso, dy*impulso, dz*impulso)
end
```

### 3. Câmera em Terceira Pessoa
```lua
-- Posiciona câmera atrás do player
function atualizaCamera()
    -- Pega player e posição
    local player = getLocalPlayer()
    local x, y, z = getElementPosition(player)
    local _, _, rz = getElementRotation(player)
    
    -- Converte ângulo pra radianos
    local angulo = math.rad(rz)
    
    -- Calcula offset da câmera
    local dist = 5
    local altura = 2
    local cx = x - math.sin(angulo) * dist
    local cy = y - math.cos(angulo) * dist
    local cz = z + altura
    
    -- Mira no player
    setCameraMatrix(cx, cy, cz, x, y, z)
end
```

## Dicas Importantes

### 1. Performance
```lua
-- Cache funções math
local sqrt = math.sqrt
local sin = math.sin
local cos = math.cos

-- Evita raiz quando possível
function comparaDistancia(x1, y1, z1, x2, y2, z2, maxDist)
    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1
    local distSq = dx*dx + dy*dy + dz*dz
    return distSq < maxDist*maxDist
end
```

### 2. Precisão
```lua
-- Arredonda pra evitar erros
function arredonda(x, casas)
    local mult = 10^(casas or 0)
    return math.floor(x * mult + 0.5) / mult
end

-- Compara com margem
function aproximado(a, b, margem)
    return math.abs(a - b) <= (margem or 0.001)
end
```

### 3. Debug
```lua
-- Mostra vetor
function debugVetor(x, y, z)
    local comprimento = math.sqrt(x*x + y*y + z*z)
    print(string.format("(%.2f, %.2f, %.2f) | Comp: %.2f",
        x, y, z, comprimento))
end

-- Desenha linha
function desenhaVetor(x1, y1, z1, x2, y2, z2, cor)
    dxDrawLine3D(x1, y1, z1, x2, y2, z2, cor or 0xFFFFFFFF)
end
```

## Conclusão

Vetores são importantes porque:
- Representam posições
- Controlam movimento
- Fazem física
- Base da matemática 3D

Lembra:
- Use funções helper
- Normalize quando precisar
- Cuidado com precisão
- Código limpo é código feliz!
