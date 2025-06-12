# Eventos em Lua

Vamos aprender sobre eventos em Lua? São super importantes pra fazer coisas acontecerem no seu código!

## O que são Eventos?

São sinais que acontecem quando algo específico rola no jogo, tipo:
- Player conecta
- Veículo explode
- Tiro acerta alguém
- Timer termina

## Tipos de Eventos

### 1. Eventos do MTA
```lua
-- Quando player entra
addEventHandler("onPlayerJoin", root,
    function()
        print("Player conectou:", source)
    end
)

-- Quando player morre
addEventHandler("onPlayerWasted", root,
    function(killer)
        print("Player morreu, killer:", killer)
    end
)
```

### 2. Eventos Customizados
```lua
-- Cria evento
addEvent("onMissaoCompleta", true)

-- Adiciona handler
addEventHandler("onMissaoCompleta", root,
    function(player, premio)
        print("Missão completa!", player, premio)
    end
)

-- Dispara evento
triggerEvent("onMissaoCompleta", player, 1000)
```

## Funções de Eventos

### 1. addEventHandler()
```lua
-- Básico
addEventHandler("onPlayerJoin", root,
    function()
        -- código aqui
    end
)

-- Com prioridade
addEventHandler("onPlayerJoin", root,
    function()
        -- código aqui
    end,
    false, "high"
)
```

### 2. removeEventHandler()
```lua
-- Remove handler específico
local function onJoin()
    print("Player entrou")
end

addEventHandler("onPlayerJoin", root, onJoin)
removeEventHandler("onPlayerJoin", root, onJoin)
```

### 3. triggerEvent()
```lua
-- Local
triggerEvent("onMissaoCompleta", player, premio)

-- Remoto
triggerClientEvent(player, "onMissaoCompleta", player, premio)
```

## Exemplos Práticos

### 1. Sistema de Missões
```lua
-- Eventos
addEvent("onMissaoInicio", true)
addEvent("onMissaoProgresso", true)
addEvent("onMissaoCompleta", true)

-- Handlers
local Missao = {
    iniciar = function(player)
        -- Inicia missão
        setElementData(player, "missao", true)
        triggerEvent("onMissaoInicio", player)
    end,
    
    progresso = function(player, valor)
        -- Atualiza progresso
        local atual = getElementData(player, "progresso") or 0
        setElementData(player, "progresso", atual + valor)
        
        -- Checa conclusão
        if atual + valor >= 100 then
            Missao.completar(player)
        else
            triggerEvent("onMissaoProgresso", player, atual + valor)
        end
    end,
    
    completar = function(player)
        -- Completa missão
        setElementData(player, "missao", false)
        setElementData(player, "progresso", 0)
        
        -- Dá prêmio
        local premio = 1000
        givePlayerMoney(player, premio)
        
        triggerEvent("onMissaoCompleta", player, premio)
    end
}

-- Uso
addCommandHandler("missao", function(player)
    Missao.iniciar(player)
end)
```

### 2. Sistema de Combate
```lua
-- Eventos
addEvent("onPlayerDano", true)
addEvent("onPlayerMorte", true)
addEvent("onPlayerRevive", true)

-- Sistema
local Combate = {
    dano = function(player, atacante, dano)
        -- Aplica dano
        local vida = getElementHealth(player)
        setElementHealth(player, vida - dano)
        
        -- Notifica
        triggerEvent("onPlayerDano", player, atacante, dano)
        
        -- Checa morte
        if vida - dano <= 0 then
            Combate.morte(player, atacante)
        end
    end,
    
    morte = function(player, killer)
        -- Mata player
        killPed(player)
        
        -- Notifica
        triggerEvent("onPlayerMorte", player, killer)
        
        -- Revive depois
        setTimer(function()
            Combate.revive(player)
        end, 5000, 1)
    end,
    
    revive = function(player)
        -- Revive
        spawnPlayer(player, 0, 0, 3)
        setElementHealth(player, 100)
        
        -- Notifica
        triggerEvent("onPlayerRevive", player)
    end
}

-- Handlers
addEventHandler("onPlayerDamage", root,
    function(atacante, arma, corpo, dano)
        Combate.dano(source, atacante, dano)
    end
)
```

### 3. Sistema de Veículos
```lua
-- Eventos
addEvent("onVeiculoCriado", true)
addEvent("onVeiculoDestruido", true)
addEvent("onVeiculoDano", true)

-- Sistema
local Veiculos = {
    criar = function(modelo, x, y, z)
        -- Cria veículo
        local veiculo = createVehicle(modelo, x, y, z)
        if not veiculo then
            return false, "Falha ao criar veículo"
        end
        
        -- Configura
        setElementHealth(veiculo, 1000)
        setVehicleDamageProof(veiculo, false)
        
        -- Notifica
        triggerEvent("onVeiculoCriado", veiculo)
        return veiculo
    end,
    
    destruir = function(veiculo)
        -- Notifica
        triggerEvent("onVeiculoDestruido", veiculo)
        
        -- Destroi
        destroyElement(veiculo)
    end,
    
    dano = function(veiculo, dano)
        -- Aplica dano
        local vida = getElementHealth(veiculo)
        setElementHealth(veiculo, vida - dano)
        
        -- Notifica
        triggerEvent("onVeiculoDano", veiculo, dano)
        
        -- Checa destruição
        if vida - dano <= 0 then
            Veiculos.destruir(veiculo)
        end
    end
}

-- Handlers
addEventHandler("onVehicleDamage", root,
    function(dano)
        Veiculos.dano(source, dano)
    end
)
```

## Dicas Importantes

### 1. Prioridades
```lua
-- Ordem de execução
addEventHandler("onPlayerJoin", root,
    function() print("1") end,
    false, "high"
)

addEventHandler("onPlayerJoin", root,
    function() print("2") end,
    false, "normal"
)

addEventHandler("onPlayerJoin", root,
    function() print("3") end,
    false, "low"
)
```

### 2. Propagação
```lua
-- Para propagação
addEventHandler("onPlayerDamage", root,
    function()
        cancelEvent()  -- cancela dano
    end
)

-- Checa cancelamento
addEventHandler("onPlayerDamage", root,
    function()
        if wasEventCancelled() then
            print("Dano cancelado")
        end
    end
)
```

### 3. Debug
```lua
-- Log de eventos
function logEvento(evento, source, ...)
    print(string.format("[%s] %s: %s",
        evento,
        getElementType(source),
        table.concat({...}, ", ")
    ))
end

-- Uso
addEventHandler("onPlayerJoin", root,
    function()
        logEvento("JOIN", source)
    end
)
```

## Conclusão

Eventos são importantes porque:
- Organizam código
- Reagem a mudanças
- Comunicam sistemas
- Controlam fluxo

Lembra:
- Use nomes claros
- Cuide das prioridades
- Trate erros
- Código limpo é código feliz!
