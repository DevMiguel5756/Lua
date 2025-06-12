# Tipos de Dados em Lua

E aí dev! Vamo conhecer os tipos de dados que a gente usa em Lua? É super importante saber isso pra programar bem!

## Tipos Básicos

### 1. nil
É o tipo que representa "nada" ou "valor indefinido":
```lua
local x = nil  -- variável sem valor
local y       -- também é nil por padrão

if x == nil then
    print("x não tem valor!")
end
```

### 2. boolean
Representa verdadeiro (true) ou falso (false):
```lua
local ligado = true
local desligado = false

if ligado then
    print("Tá ligado!")
end
```

### 3. number
Números! Podem ser inteiros ou decimais:
```lua
local idade = 25        -- inteiro
local altura = 1.75     -- decimal
local negativo = -10    -- número negativo
local grande = 1e6      -- notação científica (1 milhão)
```

### 4. string
Texto! Pode usar aspas simples ou duplas:
```lua
local nome = "João"
local sobrenome = 'Silva'
local frase = "Olá " .. nome  -- junta strings com ..

-- Strings multilinha
local texto = [[
    Isso é um texto
    com várias linhas!
    Legal né?
]]
```

### 5. function
Funções são valores em Lua:
```lua
-- Função normal
local function soma(a, b)
    return a + b
end

-- Função anônima
local multiplica = function(a, b)
    return a * b
end

-- Chamando funções
print(soma(2, 3))       -- 5
print(multiplica(4, 2)) -- 8
```

### 6. table
Estrutura mais versátil de Lua:
```lua
-- Como array
local frutas = {"maçã", "banana", "uva"}

-- Como dicionário
local pessoa = {
    nome = "Maria",
    idade = 30
}

-- Misturado
local dados = {
    1, 2, 3,
    nome = "teste",
    {x = 10, y = 20}
}
```

### 7. userdata
Tipo especial pra dados externos (como no MTA):
```lua
local player = getLocalPlayer() -- retorna userdata
local vehicle = createVehicle(411, 0, 0, 3) -- também é userdata
```

## Verificando Tipos

### 1. type()
```lua
local x = 10
local y = "teste"
local z = {1, 2, 3}

print(type(x))  -- "number"
print(type(y))  -- "string"
print(type(z))  -- "table"
```

### 2. Conversões
```lua
-- String pra número
local num = tonumber("123")     -- 123
local dec = tonumber("12.34")   -- 12.34

-- Número pra string
local str = tostring(123)       -- "123"
local hex = string.format("%x", 255)  -- "ff"
```

## Exemplos Práticos

### 1. Validação de Dados
```lua
function validarJogador(dados)
    -- Checa tipo
    if type(dados) ~= "table" then
        return false, "Dados inválidos"
    end
    
    -- Checa campos
    if type(dados.nome) ~= "string" then
        return false, "Nome deve ser string"
    end
    
    if type(dados.idade) ~= "number" then
        return false, "Idade deve ser número"
    end
    
    if type(dados.admin) ~= "boolean" then
        return false, "Admin deve ser boolean"
    end
    
    return true
end

-- Uso
local dados = {
    nome = "João",
    idade = 25,
    admin = false
}

local ok, erro = validarJogador(dados)
if not ok then
    print("Erro:", erro)
end
```

### 2. Sistema de Score
```lua
local Scores = {
    dados = {},
    
    adicionar = function(self, jogador, pontos)
        -- Valida tipos
        if type(jogador) ~= "string" then
            return false, "Jogador deve ser string"
        end
        
        if type(pontos) ~= "number" then
            return false, "Pontos deve ser número"
        end
        
        -- Adiciona/atualiza pontos
        self.dados[jogador] = (self.dados[jogador] or 0) + pontos
        return true
    end,
    
    getPontos = function(self, jogador)
        return self.dados[jogador] or 0
    end,
    
    getRanking = function(self)
        local lista = {}
        
        -- Converte pra lista
        for jogador, pontos in pairs(self.dados) do
            table.insert(lista, {
                nome = jogador,
                pontos = pontos
            })
        end
        
        -- Ordena
        table.sort(lista, function(a, b)
            return a.pontos > b.pontos
        end)
        
        return lista
    end
}

-- Uso
Scores:adicionar("João", 100)
Scores:adicionar("Maria", 150)

local ranking = Scores:getRanking()
for i, dados in ipairs(ranking) do
    print(i, dados.nome, dados.pontos)
end
```

### 3. Parser Simples
```lua
function parseValor(str)
    -- Tenta número
    local num = tonumber(str)
    if num then return num end
    
    -- Boolean
    if str == "true" then return true end
    if str == "false" then return false end
    
    -- nil
    if str == "nil" then return nil end
    
    -- String (mantém como está)
    return str
end

-- Uso
print(parseValor("123"))     -- 123
print(parseValor("true"))    -- true
print(parseValor("teste"))   -- "teste"
print(parseValor("nil"))     -- nil
```

## Dicas Importantes

### 1. nil vs false
```lua
-- nil e false são "falsy"
if nil then
    print("nunca executa")
end

if false then
    print("nunca executa")
end

-- MAS são diferentes
print(nil == false)  -- false
```

### 2. Números
```lua
-- Divisão sempre dá decimal
print(5 / 2)  -- 2.5

-- Pra ter divisão inteira
print(math.floor(5 / 2))  -- 2

-- Cuidado com decimais
print(0.1 + 0.2)  -- pode dar 0.30000000000000004
```

### 3. Strings
```lua
-- Comparação é case-sensitive
print("Lua" == "lua")  -- false

-- Concatenar muitas strings
local partes = {"a", "b", "c", "d"}
print(table.concat(partes))  -- mais rápido que .. 

-- Padrões (patterns)
local nome = string.match("João Silva", "(%w+)%s+(%w+)")
```

## Conclusão

Tipos em Lua são:
- Simples de entender
- Fáceis de usar
- Flexíveis
- Base de tudo!

Lembra:
- Use type() pra checar tipos
- Valide dados de entrada
- Cuide com conversões
- Código limpo é código feliz!
