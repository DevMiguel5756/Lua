# Debug em Lua - Como Achar e Resolver Bugs 

E aí dev! Vamo aprender sobre debugging em Lua? É super importante saber encontrar e corrigir bugs no seu código!

## O que é Debugging?

É o processo de:
- Encontrar bugs
- Entender o problema
- Corrigir o erro
- Testar a solução

## Ferramentas Básicas

### 1. print()
```lua
-- Mostra valores
local vida = 100
print("Vida:", vida)

-- Mostra tabelas
local player = {
    nome = "João",
    vida = 100
}
print("Player:", table.concat(player, ", "))
```

### 2. assert()
```lua
-- Checa condições
local vida = -10
assert(vida >= 0, "Vida não pode ser negativa!")

-- Valida parâmetros
function dano(valor)
    assert(type(valor) == "number", "Valor deve ser número")
    assert(valor > 0, "Dano deve ser positivo")
end
```

### 3. error()
```lua
-- Lança erro
function divide(a, b)
    if b == 0 then
        error("Divisão por zero!")
    end
    return a/b
end
```

## Funções de Debug

### 1. debug.traceback()
```lua
-- Mostra pilha de chamadas
function funcao3()
    print(debug.traceback())
end

function funcao2()
    funcao3()
end

function funcao1()
    funcao2()
end
```

### 2. debug.getinfo()
```lua
-- Info da função atual
local info = debug.getinfo(1)
print("Linha:", info.currentline)
print("Função:", info.name)
print("Arquivo:", info.source)
```

### 3. debug.getlocal()
```lua
-- Variáveis locais
local function getLocals()
    local a = 10
    local b = 20
    
    for i = 1, 10 do
        local nome, valor = debug.getlocal(1, i)
        if not nome then break end
        print(nome, "=", valor)
    end
end
```

## Exemplos Práticos

### 1. Logger Simples
```lua
local Logger = {
    nivel = "info",
    niveis = {
        debug = 1,
        info = 2,
        warn = 3,
        error = 4
    }
}

function Logger:log(nivel, msg, ...)
    -- Checa nível
    if self.niveis[nivel] < self.niveis[self.nivel] then
        return
    end
    
    -- Formata mensagem
    local texto = string.format(msg, ...)
    
    -- Adiciona info
    local info = debug.getinfo(2)
    texto = string.format("[%s:%d] %s: %s",
        info.source,
        info.currentline,
        nivel:upper(),
        texto
    )
    
    -- Salva/mostra
    outputDebugString(texto)
end

-- Uso
Logger:log("info", "Player %s conectou", "João")
Logger:log("error", "Erro ao carregar mapa")
```

### 2. Sistema de Erros
```lua
function tryCatch(fn)
    return function(...)
        local ok, resultado = pcall(fn, ...)
        if not ok then
            -- Log do erro
            local erro = tostring(resultado)
            local stack = debug.traceback()
            
            outputDebugString("=== ERRO ===")
            outputDebugString(erro)
            outputDebugString("=== STACK ===")
            outputDebugString(stack)
            
            return false, erro
        end
        return true, resultado
    end
end

-- Uso
local funcaoSegura = tryCatch(function(x)
    assert(x > 0, "X deve ser positivo")
    return 1/x
end)

local ok, resultado = funcaoSegura(-1)
if not ok then
    print("Erro:", resultado)
end
```

### 3. Monitor de Performance
```lua
local Monitor = {
    tempos = {},
    ativo = false
}

function Monitor:inicio(nome)
    if not self.ativo then return end
    self.tempos[nome] = {
        inicio = getTickCount(),
        chamadas = 0
    }
end

function Monitor:fim(nome)
    if not self.ativo then return end
    local dados = self.tempos[nome]
    if not dados then return end
    
    dados.chamadas = dados.chamadas + 1
    dados.total = (dados.total or 0) + 
                 (getTickCount() - dados.inicio)
end

function Monitor:relatorio()
    print("=== PERFORMANCE ===")
    for nome, dados in pairs(self.tempos) do
        local media = dados.total / dados.chamadas
        print(string.format("%s: %.2fms (%d calls)",
            nome, media, dados.chamadas))
    end
end

-- Uso
Monitor.ativo = true
Monitor:inicio("processo")
-- código aqui
Monitor:fim("processo")
Monitor:relatorio()
```

## Dicas Importantes

### 1. Logs Úteis
```lua
-- Contexto ajuda
function logErro(msg, ...)
    local info = debug.getinfo(2)
    local texto = string.format(
        "[%s:%d] %s",
        info.source,
        info.currentline,
        string.format(msg, ...)
    )
    outputDebugString(texto, 1)
end

-- Níveis diferentes
function log(nivel, msg)
    local cores = {
        info = "0088FF",
        warn = "FFBB00",
        error = "FF0000"
    }
    local cor = cores[nivel] or "FFFFFF"
    outputChatBox(msg, root, cor)
end
```

### 2. Validações
```lua
-- Checa parâmetros
function validaPlayer(player)
    if not isElement(player) then
        return false, "Player inválido"
    end
    
    if getElementType(player) ~= "player" then
        return false, "Elemento não é player"
    end
    
    if not isElementAlive(player) then
        return false, "Player morto"
    end
    
    return true
end

-- Uso
local ok, erro = validaPlayer(source)
if not ok then
    return logErro(erro)
end
```

### 3. Debug Visual
```lua
-- Mostra hitbox
function debugHitbox(elemento)
    local x, y, z = getElementPosition(elemento)
    local rx, ry, rz = getElementRotation(elemento)
    local matriz = getElementMatrix(elemento)
    
    -- Desenha linhas
    for i = 1, 8 do
        local x1, y1, z1 = getVertexPosition(matriz, i)
        local x2, y2, z2 = getVertexPosition(matriz, i+1)
        dxDrawLine3D(x1, y1, z1, x2, y2, z2, 0xFFFF0000)
    end
end
```

## Conclusão

Debugging é importante porque:
- Acha problemas
- Entende o código
- Melhora qualidade
- Evita bugs futuros

Lembra:
- Use logs úteis
- Valide dados
- Trate erros
- Código limpo é código feliz!
