# Operadores em Lua

E aí dev! Vamo aprender sobre os operadores em Lua? São super importantes pra fazer cálculos e comparações no seu código!

## Operadores Aritméticos

### Básicos
```lua
local a = 10
local b = 3

print(a + b)  -- Soma: 13
print(a - b)  -- Subtração: 7
print(a * b)  -- Multiplicação: 30
print(a / b)  -- Divisão: 3.3333...
print(a % b)  -- Resto: 1
print(a ^ b)  -- Potência: 1000
print(-a)     -- Negativo: -10
```

### Exemplos Práticos
```lua
-- Calculando dano com bônus
local danoBase = 50
local multiplicadorCritico = 1.5
local danoFinal = danoBase * multiplicadorCritico

-- Calculando nível
local xp = 1500
local nivelBase = 1
local xpPorNivel = 100
local nivel = nivelBase + math.floor(xp / xpPorNivel)

-- Calculando preço com desconto
local precoOriginal = 100
local desconto = 0.2  -- 20%
local precoFinal = precoOriginal * (1 - desconto)
```

## Operadores de Comparação

### Básicos
```lua
local a = 10
local b = 20

print(a == b)  -- Igual: false
print(a ~= b)  -- Diferente: true
print(a < b)   -- Menor que: true
print(a > b)   -- Maior que: false
print(a <= b)  -- Menor ou igual: true
print(a >= b)  -- Maior ou igual: false
```

### Exemplos Práticos
```lua
-- Verificando nível pra usar item
local nivelJogador = 10
local nivelRequirido = 15

if nivelJogador >= nivelRequirido then
    print("Pode usar o item!")
else
    print("Nível muito baixo!")
end

-- Verificando se tem dinheiro
local dinheiroJogador = 1000
local precoItem = 1500

if dinheiroJogador >= precoItem then
    print("Pode comprar!")
else
    print("Dinheiro insuficiente!")
end
```

## Operadores Lógicos

### Básicos
```lua
local a = true
local b = false

print(a and b)  -- E lógico: false
print(a or b)   -- OU lógico: true
print(not a)    -- NÃO lógico: false
```

### Exemplos Práticos
```lua
-- Verificando condições de missão
local temItem = true
local nivelSuficiente = true
local podeIniciarMissao = temItem and nivelSuficiente

-- Verificando condições de dano
local comArmadura = false
local comEscudo = true
local temProtecao = comArmadura or comEscudo

-- Verificando status
local estaInvisivel = true
local podeSerVisto = not estaInvisivel
```

## Operadores de Concatenação

### Básicos
```lua
local nome = "João"
local sobrenome = "Silva"

print(nome .. " " .. sobrenome)  -- João Silva
```

### Exemplos Práticos
```lua
-- Mensagem de boas vindas
local nomeJogador = "Carlos"
local mensagem = "Bem vindo, " .. nomeJogador .. "!"

-- Mensagem de level up
local novoNivel = 10
local mensagemNivel = "Parabéns! Você alcançou o nível " .. novoNivel

-- Mensagem de item
local nomeItem = "Espada"
local quantidade = 2
local mensagemItem = "Você ganhou " .. quantidade .. "x " .. nomeItem
```

## Operadores de Comprimento

### Básicos
```lua
local texto = "Lua"
local tabela = {1, 2, 3, 4}

print(#texto)    -- Comprimento do texto: 3
print(#tabela)   -- Tamanho da tabela: 4
```

### Exemplos Práticos
```lua
-- Verificando inventário
local inventario = {"poção", "espada", "escudo"}
local espacosLivres = 10 - #inventario

-- Verificando senha
local senha = "123456"
if #senha < 6 then
    print("Senha muito curta!")
end

-- Verificando texto
local mensagem = "Oi!"
if #mensagem > 100 then
    print("Mensagem muito longa!")
end
```

## Dicas Importantes

### 1. Cuidado com Divisão por Zero
```lua
-- Sempre verifique antes de dividir
local a = 10
local b = 0

if b ~= 0 then
    print(a / b)
else
    print("Não pode dividir por zero!")
end
```

### 2. Use Parênteses pra Clareza
```lua
-- Sem parênteses (confuso)
local resultado = 2 + 3 * 4

-- Com parênteses (claro)
local resultado = (2 + 3) * 4
```

### 3. Cuidado com Comparações
```lua
-- Comparando números
if tonumber("123") == 123 then
    print("São iguais!")
end

-- Comparando strings
if tostring(123) == "123" then
    print("São iguais!")
end
```

## Conclusão

Operadores são essenciais porque:
- Fazem cálculos
- Comparam valores
- Controlam lógica
- Manipulam texto

Lembra:
- Use parênteses pra clareza
- Cuidado com divisão por zero
- Verifique tipos antes de comparar
- Código limpo é código feliz
