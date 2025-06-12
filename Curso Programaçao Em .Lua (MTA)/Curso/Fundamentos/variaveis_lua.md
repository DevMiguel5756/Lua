# Variáveis em Lua

Variáveis são fundamentais em programação e em Lua não é diferente. Elas são usadas para armazenar valores que podem ser utilizados posteriormente no código.

## Tipos de Variáveis

Lua suporta vários tipos de variáveis, incluindo:

### 1. Números
```lua
local numero = 42        -- Inteiro
local decimal = 3.14     -- Decimal
local negativo = -10     -- Negativo
```

### 2. Strings
```lua
local nome = "João"      -- Com aspas duplas
local texto = 'Olá'      -- Com aspas simples
local multi = [[
    Texto em
    múltiplas linhas
]]
```

### 3. Booleanos
```lua
local verdadeiro = true
local falso = false
```

### 4. nil
```lua
local vazio = nil        -- Representa ausência de valor
```

## Escopo de Variáveis

### 1. Local
```lua
local x = 10            -- Variável local
```

### 2. Global
```lua
y = 20                  -- Variável global
_G.z = 30              -- Variável global explícita
```

## Boas Práticas

1. **Use sempre local**
```lua
-- Bom
local contador = 0

-- Evite
contador = 0
```

2. **Nomes descritivos**
```lua
-- Bom
local velocidadeMaxima = 200

-- Evite
local v = 200
```

3. **Convenções de nomenclatura**
```lua
local nomeJogador      -- camelCase para variáveis
local LIMITE_MAXIMO    -- SNAKE_CASE para constantes
```

## Exemplos Práticos

### 1. Concatenação de Strings
```lua
local nome = "João"
local sobrenome = "Silva"
local nomeCompleto = nome .. " " .. sobrenome
```

### 2. Conversão de Tipos
```lua
local numero = "42"
local numeroConvertido = tonumber(numero)

local valor = 3.14
local textoValor = tostring(valor)
```

### 3. Verificação de Tipo
```lua
local x = 42
print(type(x))         -- "number"

local y = "texto"
print(type(y))         -- "string"
```

## Exercícios

1. Crie variáveis para armazenar:
   - Nome do jogador
   - Vida do jogador
   - Posição X, Y, Z
   - Status (vivo/morto)

2. Faça operações com strings:
   - Concatene nome e sobrenome
   - Converta números para texto
   - Converta texto para números

3. Pratique escopos:
   - Crie variáveis locais
   - Entenda quando usar globais
   - Teste diferentes escopos

## Conclusão

Variáveis são fundamentais em Lua e MTA:SA. Use-as corretamente para:
- Armazenar dados do jogador
- Controlar estados do jogo
- Manipular informações temporárias
- Manter configurações
