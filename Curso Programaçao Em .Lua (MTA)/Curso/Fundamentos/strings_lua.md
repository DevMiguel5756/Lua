# Strings em Lua

Vamos aprender sobre strings em Lua? São super importantes pra trabalhar com texto!

## O que são Strings?

São textos! Qualquer coisa entre aspas é uma string em Lua.

## Criando Strings

### 1. Aspas Simples e Duplas
```lua
local nome = "João"
local sobrenome = 'Silva'
```

### 2. Strings Longas
```lua
local texto = [[
    Este é um texto longo
    que pode ter várias linhas
    sem precisar de \n
]]
```

## Operações com Strings

### 1. Concatenação
```lua
-- Com ..
local nomeCompleto = nome .. " " .. sobrenome

-- Com format
local msg = string.format(
    "Nome: %s %s",
    nome, sobrenome
)
```

### 2. Tamanho
```lua
-- Com #
local tamanho = #nome

-- Com len
local tam = string.len(nome)
```

### 3. Maiúsculo/Minúsculo
```lua
-- Maiúsculo
local upper = string.upper(nome)

-- Minúsculo
local lower = string.lower(nome)
```

## Funções de String

### 1. Sub-strings
```lua
-- Pega parte
local parte = string.sub(nome, 1, 3)

-- Do fim
local fim = string.sub(nome, -3)
```

### 2. Encontrar
```lua
-- Acha primeira
local pos = string.find(texto, "palavra")

-- Acha todas
for pos in string.gmatch(texto, "palavra") do
    print(pos)
end
```

### 3. Substituir
```lua
-- Uma vez
local novo = string.gsub(texto, "velho", "novo")

-- Várias vezes
local novo, n = string.gsub(texto, "velho", "novo")
```

## Exemplos Práticos

### 1. Sistema de Chat
```lua
-- Funções de chat
local Chat = {
    formatar = function(msg)
        -- Tira espaços
        msg = string.trim(msg)
        
        -- Primeira letra maiúscula
        msg = string.upper(string.sub(msg, 1, 1)) ..
              string.lower(string.sub(msg, 2))
              
        return msg
    end,
    
    filtrar = function(msg)
        -- Lista de palavras ruins
        local blacklist = {
            "palavra1",
            "palavra2"
        }
        
        -- Substitui palavras
        for _, palavra in ipairs(blacklist) do
            msg = string.gsub(msg, palavra, "***")
        end
        
        return msg
    end,
    
    enviar = function(player, msg)
        -- Formata e filtra
        msg = Chat.formatar(msg)
        msg = Chat.filtrar(msg)
        
        -- Envia
        outputChatBox(msg, player)
    end
}

-- Uso
Chat.enviar(player, "   oi pessoal   ")
```

### 2. Sistema de Comandos
```lua
-- Parser de comandos
local Comandos = {
    parse = function(str)
        -- Separa comando e args
        local cmd, args = string.match(str, "^/(%w+)%s*(.*)")
        if not cmd then return end
        
        -- Separa argumentos
        local argsList = {}
        for arg in string.gmatch(args, "%S+") do
            table.insert(argsList, arg)
        end
        
        return cmd, argsList
    end,
    
    executar = function(player, str)
        -- Parse comando
        local cmd, args = Comandos.parse(str)
        if not cmd then return end
        
        -- Executa
        if cmd == "tp" then
            local x = tonumber(args[1])
            local y = tonumber(args[2])
            local z = tonumber(args[3])
            
            if x and y and z then
                setElementPosition(player, x, y, z)
            end
        end
    end
}

-- Uso
addEventHandler("onPlayerCommand", root,
    function(cmd)
        Comandos.executar(source, cmd)
    end
)
```

### 3. Sistema de Nomes
```lua
-- Funções de nome
local Nomes = {
    validar = function(nome)
        -- Tamanho
        if #nome < 3 or #nome > 20 then
            return false, "Tamanho inválido"
        end
        
        -- Só letras e números
        if string.match(nome, "[^%w_]") then
            return false, "Caracteres inválidos"
        end
        
        return true
    end,
    
    formatar = function(nome)
        -- Tira espaços
        nome = string.trim(nome)
        
        -- Primeira maiúscula
        nome = string.upper(string.sub(nome, 1, 1)) ..
               string.lower(string.sub(nome, 2))
               
        return nome
    end,
    
    mudar = function(player, nome)
        -- Valida
        local ok, erro = Nomes.validar(nome)
        if not ok then
            return false, erro
        end
        
        -- Formata
        nome = Nomes.formatar(nome)
        
        -- Muda
        setPlayerName(player, nome)
        return true
    end
}

-- Uso
Nomes.mudar(player, "joao_silva")
```

## Dicas Importantes

### 1. Performance
```lua
-- Cache de funções
local upper = string.upper
local lower = string.lower
local format = string.format

-- Melhor que chamar string.* toda hora
local function formatar(nome)
    return upper(nome:sub(1,1)) .. 
           lower(nome:sub(2))
end
```

### 2. Memória
```lua
-- Evita criar strings demais
local function log(tipo, msg)
    local texto = format("[%s] %s", tipo, msg)
    outputDebugString(texto)
end

-- Ruim: cria muitas strings
local texto = ""
for i = 1, 1000 do
    texto = texto .. i .. ","
end

-- Melhor: usa table
local t = {}
for i = 1, 1000 do
    t[i] = tostring(i)
end
local texto = table.concat(t, ",")
```

### 3. Padrões
```lua
-- Padrões úteis
local patterns = {
    email = "^[%w.]+@[%w.]+%.%w+$",
    numero = "^%d+$",
    alfanum = "^%w+$"
}

-- Uso
local str = "teste@email.com"
if string.match(str, patterns.email) then
    print("É email!")
end
```

## Conclusão

Strings são importantes porque:
- Processam texto
- Formatam dados
- Validam entrada
- Melhoram interface

Lembra:
- Use funções certas
- Cuide da performance
- Valide entrada
- Código limpo é código feliz!
