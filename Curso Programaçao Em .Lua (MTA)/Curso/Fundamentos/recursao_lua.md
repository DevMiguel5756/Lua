# Recursão em Lua

E aí dev! Vamo aprender sobre recursão? É quando uma função chama ela mesma!

## O que é Recursão?

Recursão acontece quando uma função chama ela mesma pra resolver um problema menor do mesmo tipo.

### Exemplo Básico
```lua
function contagem(n)
    if n <= 0 then
        return
    end
    print(n)
    contagem(n - 1)
end

contagem(5)  -- Printa: 5, 4, 3, 2, 1
```

## Exemplos Práticos

### 1. Fatorial
```lua
function fatorial(n)
    if n <= 1 then
        return 1
    end
    return n * fatorial(n - 1)
end

print(fatorial(5))  -- 120 (5 * 4 * 3 * 2 * 1)
```

### 2. Fibonacci
```lua
function fibonacci(n)
    if n <= 2 then
        return 1
    end
    return fibonacci(n - 1) + fibonacci(n - 2)
end

print(fibonacci(6))  -- 8 (1, 1, 2, 3, 5, 8)
```

### 3. Busca em Árvore
```lua
local arvore = {
    valor = 10,
    esquerda = {
        valor = 5,
        esquerda = {
            valor = 3
        }
    },
    direita = {
        valor = 15,
        direita = {
            valor = 20
        }
    }
}

function buscar(no, valor)
    if not no then
        return false
    end
    
    if no.valor == valor then
        return true
    end
    
    return buscar(no.esquerda, valor) or buscar(no.direita, valor)
end

print(buscar(arvore, 3))   -- true
print(buscar(arvore, 12))  -- false
```

## Exemplos no MTA

### 1. Busca de Elementos
```lua
function buscarFilhos(elemento, tipo)
    local encontrados = {}
    
    -- Procura no elemento atual
    if getElementType(elemento) == tipo then
        table.insert(encontrados, elemento)
    end
    
    -- Procura nos filhos
    local filhos = getElementChildren(elemento)
    for _, filho in ipairs(filhos) do
        local resultados = buscarFilhos(filho, tipo)
        for _, resultado in ipairs(resultados) do
            table.insert(encontrados, resultado)
        end
    end
    
    return encontrados
end

-- Uso
local markers = buscarFilhos(resourceRoot, "marker")
```

### 2. Sistema de Menu
```lua
local menu = {
    nome = "Principal",
    itens = {
        {
            nome = "Jogador",
            itens = {
                {
                    nome = "Vida",
                    acao = function() end
                },
                {
                    nome = "Armas",
                    itens = {
                        {
                            nome = "Pistola",
                            acao = function() end
                        }
                    }
                }
            }
        }
    }
}

function processarMenu(item, nivel)
    nivel = nivel or 0
    local espacos = string.rep("  ", nivel)
    
    print(espacos .. item.nome)
    
    if item.itens then
        for _, subitem in ipairs(item.itens) do
            processarMenu(subitem, nivel + 1)
        end
    end
end

processarMenu(menu)
```

### 3. Sistema de Inventário
```lua
function calcularPesoTotal(item)
    local peso = item.peso or 0
    
    if item.itens then
        for _, subitem in ipairs(item.itens) do
            peso = peso + calcularPesoTotal(subitem)
        end
    end
    
    return peso
end

-- Exemplo de uso
local mochila = {
    nome = "Mochila",
    peso = 1,
    itens = {
        {
            nome = "Poção",
            peso = 0.5
        },
        {
            nome = "Caixa",
            peso = 1,
            itens = {
                {
                    nome = "Anel",
                    peso = 0.1
                }
            }
        }
    }
}

print(calcularPesoTotal(mochila))  -- 2.6
```

## Dicas Importantes

### 1. Caso Base
```lua
-- Ruim: sem caso base
function loop(n)
    return loop(n)  -- Loop infinito!
end

-- Bom: tem caso base
function loop(n)
    if n <= 0 then  -- Caso base
        return
    end
    return loop(n - 1)
end
```

### 2. Profundidade da Pilha
```lua
-- Pode estourar a pilha
function muitoFundo(n)
    if n <= 0 then return end
    muitoFundo(n - 1)
end

-- Melhor: usa loop
function maisSeguro(n)
    while n > 0 do
        n = n - 1
    end
end
```

### 3. Cache de Resultados
```lua
local cache = {}

function fibonacciRapido(n)
    if n <= 2 then
        return 1
    end
    
    if cache[n] then
        return cache[n]
    end
    
    cache[n] = fibonacciRapido(n - 1) + fibonacciRapido(n - 2)
    return cache[n]
end
```

## Conclusão

Recursão é importante porque:
- Resolve problemas complexos
- Deixa o código mais limpo
- É boa pra estruturas aninhadas

Lembra:
- Sempre tenha caso base
- Cuidado com a pilha
- Use cache quando puder
- Código limpo é código feliz
