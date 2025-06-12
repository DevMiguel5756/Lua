# Condicionais em Lua

Vamos aprender sobre condicionais em Lua? São estruturas que permitem que seu código tome decisões baseadas em condições.

## O que são Condicionais?

São estruturas que permitem que seu código tome decisões baseadas em condições. É tipo um "se isso, faça aquilo".

## Tipos de Condicionais

### 1. if simples
```lua
local vida = 50

if vida < 100 then
    print("Precisa de cura!")
end
```

### 2. if/else
```lua
local admin = false

if admin then
    print("Você é admin!")
else
    print("Você não é admin!")
end
```

### 3. if/elseif/else
```lua
local nivel = 5

if nivel < 5 then
    print("Iniciante")
elseif nivel < 10 then
    print("Intermediário")
else
    print("Avançado")
end
```

## Operadores Lógicos

### 1. and (E)
```lua
local vida = 80
local colete = 100

if vida > 50 and colete > 50 then
    print("Tá bem protegido!")
end
```

### 2. or (OU)
```lua
local municao = 0
local vida = 20

if municao == 0 or vida < 30 then
    print("Situação perigosa!")
end
```

### 3. not (NÃO)
```lua
local morto = false

if not morto then
    print("Ainda tá vivo!")
end
```

## Exemplos Práticos

### 1. Sistema de Dano
```lua
function aplicaDano(alvo, dano)
    -- Pega status
    local vida = getElementHealth(alvo)
    local colete = getPedArmor(alvo)
    
    -- Checa invencibilidade
    if getElementData(alvo, "invencivel") then
        return false, "Alvo invencível"
    end
    
    -- Aplica no colete primeiro
    if colete > 0 then
        if colete >= dano then
            setPedArmor(alvo, colete - dano)
            return true
        else
            dano = dano - colete
            setPedArmor(alvo, 0)
        end
    end
    
    -- Aplica na vida
    local novaVida = vida - dano
    if novaVida <= 0 then
        killPed(alvo)
    else
        setElementHealth(alvo, novaVida)
    end
    
    return true
end
```

### 2. Sistema de Level
```lua
function checaLevel(player)
    local xp = getElementData(player, "xp") or 0
    local level = getElementData(player, "level") or 1
    
    -- XP necessário pro próximo level
    local xpNecessario = level * 1000
    
    -- Sobe de level
    if xp >= xpNecessario then
        -- Reseta XP e aumenta level
        setElementData(player, "xp", xp - xpNecessario)
        setElementData(player, "level", level + 1)
        
        -- Recompensas por level
        if level % 5 == 0 then
            -- Level múltiplo de 5
            darPremioEspecial(player)
        else
            -- Level normal
            darPremioNormal(player)
        end
        
        return true
    end
    
    return false
end
```

### 3. Sistema de Permissões
```lua
function checaPermissao(player, acao)
    -- Pega dados
    local admin = getElementData(player, "admin")
    local vip = getElementData(player, "vip")
    local level = getElementData(player, "level") or 1
    
    -- Admin pode tudo
    if admin then
        return true
    end
    
    -- Checa ação específica
    if acao == "spawn_car" then
        -- Precisa ser VIP ou level 10+
        return vip or level >= 10
        
    elseif acao == "teleport" then
        -- Só VIP pode
        return vip
        
    elseif acao == "heal" then
        -- Level 5+ pode
        return level >= 5
    end
    
    -- Ação não reconhecida
    return false
end
```

## Dicas Importantes

### 1. Evite Aninhamento
```lua
-- Ruim: muito aninhado
if condicao1 then
    if condicao2 then
        if condicao3 then
            -- código
        end
    end
end

-- Melhor: retorno antecipado
if not condicao1 then return end
if not condicao2 then return end
if not condicao3 then return end
-- código
```

### 2. Use Funções Helper
```lua
-- Helper pra checar player
function isPlayerElegivel(player)
    return getElementData(player, "level") >= 5 and
           not getElementData(player, "banido") and
           getElementHealth(player) > 0
end

-- Uso
if isPlayerElegivel(player) then
    darPremio(player)
end
```

### 3. Valores Padrão
```lua
-- Com operador or
local vida = getElementData(player, "vida") or 100

-- Com ternário
local admin = isPlayerAdmin(player) and true or false
```

## Conclusão

Condicionais são importantes porque:
- Controlam o fluxo
- Tomam decisões
- Validam dados
- Deixam código mais esperto

Lembra:
- Mantenha simples
- Evite muito aninhamento
- Use funções helper
- Código limpo é código feliz!
