# Tabelas em Lua

E aí dev! Vamo aprender sobre tabelas? São super importantes em Lua!

## O que são Tabelas?

Tabelas são estruturas que guardam dados em Lua. Podem ser usadas como:
- Arrays
- Dicionários
- Objetos
- Listas

## Criando Tabelas

### Arrays
```lua
-- Array simples
local numeros = {1, 2, 3, 4, 5}

-- Array de strings
local nomes = {"João", "Maria", "Pedro"}

-- Array misto
local dados = {10, "texto", true, {1, 2}}
```

### Dicionários
```lua
-- Com strings
local jogador = {
    nome = "João",
    vida = 100,
    arma = "pistola"
}

-- Com outros tipos
local config = {
    [1] = "primeiro",
    [true] = "verdadeiro",
    [{}] = "tabela"
}
```

## Acessando Dados

### Arrays
```lua
local frutas = {"maçã", "banana", "laranja"}

-- Índices começam em 1
print(frutas[1])  -- maçã
print(frutas[2])  -- banana

-- Tamanho com #
print(#frutas)  -- 3

-- Loop numérico
for i = 1, #frutas do
    print(i, frutas[i])
end
```

### Dicionários
```lua
local carro = {
    marca = "Ferrari",
    modelo = "F40",
    ano = 1992
}

-- Ponto ou colchetes
print(carro.marca)    -- Ferrari
print(carro["marca"]) -- Ferrari

-- Loop genérico
for chave, valor in pairs(carro) do
    print(chave, valor)
end
```

## Manipulando Tabelas

### 1. Inserindo e Removendo
```lua
local lista = {1, 2, 3}

-- Inserir no fim
table.insert(lista, 4)
lista[#lista + 1] = 5

-- Inserir na posição
table.insert(lista, 1, 0)

-- Remover do fim
table.remove(lista)

-- Remover da posição
table.remove(lista, 1)
```

### 2. Ordenando
```lua
local nums = {3, 1, 4, 1, 5}

-- Ordem crescente
table.sort(nums)

-- Ordem personalizada
table.sort(nums, function(a, b)
    return a > b  -- decrescente
end)
```

### 3. Copiando
```lua
-- Cópia simples
function copiaRasa(tab)
    local nova = {}
    for k, v in pairs(tab) do
        nova[k] = v
    end
    return nova
end

-- Cópia profunda
function copiaProfunda(tab)
    if type(tab) ~= "table" then
        return tab
    end
    
    local nova = {}
    for k, v in pairs(tab) do
        nova[k] = copiaProfunda(v)
    end
    return nova
end
```

## Exemplos Práticos

### 1. Inventário
```lua
local Inventario = {
    itens = {},
    
    adicionar = function(self, item)
        if #self.itens >= 10 then
            return false, "Inventário cheio"
        end
        
        table.insert(self.itens, item)
        return true
    end,
    
    remover = function(self, index)
        if index < 1 or index > #self.itens then
            return false, "Posição inválida"
        end
        
        table.remove(self.itens, index)
        return true
    end,
    
    procurar = function(self, nome)
        for i, item in ipairs(self.itens) do
            if item.nome == nome then
                return i, item
            end
        end
        return nil
    end
}

-- Uso
local inv = Inventario
inv:adicionar({nome = "Espada", dano = 10})
inv:adicionar({nome = "Poção", cura = 50})
```

### 2. Sistema de Score
```lua
local Ranking = {
    scores = {},
    
    adicionar = function(self, nome, pontos)
        self.scores[nome] = (self.scores[nome] or 0) + pontos
    end,
    
    getTop = function(self, limite)
        -- Converte pra array
        local lista = {}
        for nome, pontos in pairs(self.scores) do
            table.insert(lista, {
                nome = nome,
                pontos = pontos
            })
        end
        
        -- Ordena
        table.sort(lista, function(a, b)
            return a.pontos > b.pontos
        end)
        
        -- Limita
        if limite then
            local top = {}
            for i = 1, math.min(limite, #lista) do
                top[i] = lista[i]
            end
            return top
        end
        
        return lista
    end
}

-- Uso
local rank = Ranking
rank:adicionar("João", 100)
rank:adicionar("Maria", 150)
local top3 = rank:getTop(3)
```

### 3. Cache de Dados
```lua
local Cache = {
    dados = {},
    tempos = {},
    
    set = function(self, chave, valor, tempo)
        self.dados[chave] = valor
        if tempo then
            self.tempos[chave] = getTickCount() + tempo
        end
    end,
    
    get = function(self, chave)
        -- Checa expiração
        local expira = self.tempos[chave]
        if expira and getTickCount() > expira then
            self.dados[chave] = nil
            self.tempos[chave] = nil
            return nil
        end
        
        return self.dados[chave]
    end,
    
    limpar = function(self)
        self.dados = {}
        self.tempos = {}
    end
}

-- Uso
local cache = Cache
cache:set("jogador.1", {nome = "João"}, 5000)  -- 5 segundos
local dados = cache:get("jogador.1")
```

## Dicas Importantes

### 1. Performance
```lua
-- Ruim: recria índice
local tab = {}
for i = 1, 1000 do
    table.insert(tab, i)
end

-- Bom: usa índice direto
local tab = {}
for i = 1, 1000 do
    tab[i] = i
end
```

### 2. Memória
```lua
-- Limpar tabela
function limpar(tab)
    for k in pairs(tab) do
        tab[k] = nil
    end
end

-- Reusar tabela
local pool = {}
function getTabela()
    local tab = table.remove(pool) or {}
    return tab
end

function liberarTabela(tab)
    limpar(tab)
    table.insert(pool, tab)
end
```

### 3. Segurança
```lua
-- Congelar tabela
function congelar(tab)
    return setmetatable({}, {
        __index = tab,
        __newindex = function()
            error("Tabela congelada")
        end
    })
end

-- Validar tabela
function validar(tab, campos)
    for _, campo in ipairs(campos) do
        if tab[campo] == nil then
            return false, "Campo faltando: " .. campo
        end
    end
    return true
end
```

## Conclusão

Tabelas são importantes porque:
- Organizam dados
- Criam estruturas
- Guardam informações
- Fazem coleções

Lembra:
- Use ipairs pra arrays
- Use pairs pra dicts
- Cuide da memória
- Código limpo é código feliz
