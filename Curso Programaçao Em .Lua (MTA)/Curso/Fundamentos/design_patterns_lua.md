# Design Patterns em Lua

Vamo aprender sobre padrões de design em Lua? São super úteis pra organizar seu código!

## O que são Design Patterns?

São soluções comuns pra problemas comuns. Tipo receitas que funcionam bem pra resolver certos tipos de problemas no código.

## Padrões Mais Usados

### 1. Singleton
```lua
-- Só uma instância
local BancoSystem = {
    instance = nil,
    saldo = 0
}

function BancoSystem.getInstance()
    if not BancoSystem.instance then
        BancoSystem.instance = {
            depositar = function(valor)
                BancoSystem.saldo = BancoSystem.saldo + valor
            end,
            
            sacar = function(valor)
                if BancoSystem.saldo >= valor then
                    BancoSystem.saldo = BancoSystem.saldo - valor
                    return true
                end
                return false
            end
        }
    end
    return BancoSystem.instance
end

-- Uso
local banco = BancoSystem.getInstance()
banco.depositar(1000)
```

### 2. Factory
```lua
-- Cria objetos
local VeiculoFactory = {
    criarCarro = function(modelo, x, y, z)
        local veiculo = createVehicle(modelo, x, y, z)
        setVehicleColor(veiculo, 255, 0, 0) -- Vermelho padrão
        return veiculo
    end,
    
    criarMoto = function(modelo, x, y, z)
        local veiculo = createVehicle(modelo, x, y, z)
        setVehicleColor(veiculo, 0, 0, 0) -- Preto padrão
        return veiculo
    end
}

-- Uso
local carrão = VeiculoFactory.criarCarro(411, 100, 100, 10)
```

### 3. Observer
```lua
-- Sistema de eventos
local EventManager = {
    listeners = {},
    
    addListener = function(self, evento, func)
        if not self.listeners[evento] then
            self.listeners[evento] = {}
        end
        table.insert(self.listeners[evento], func)
    end,
    
    notify = function(self, evento, data)
        if self.listeners[evento] then
            for _, func in ipairs(self.listeners[evento]) do
                func(data)
            end
        end
    end
}

-- Uso
EventManager:addListener("playerMorreu", function(player)
    print("Player morreu:", player)
end)

-- Quando alguém morrer
EventManager:notify("playerMorreu", sourcePlayer)
```

### 4. Command
```lua
-- Encapsula ações
local Comandos = {
    darDinheiro = {
        execute = function(player, valor)
            givePlayerMoney(player, valor)
            return true
        end,
        
        undo = function(player, valor)
            takePlayerMoney(player, valor)
            return true
        end
    },
    
    darVida = {
        execute = function(player, valor)
            setElementHealth(player, valor)
            return true
        end
    }
}

-- Uso
Comandos.darDinheiro.execute(player, 1000)
```

### 5. State
```lua
-- Muda comportamento
local PlayerStates = {
    normal = {
        pular = function(player)
            setPedAnimation(player, "jump")
        end,
        
        atirar = function(player)
            -- atira normal
        end
    },
    
    machucado = {
        pular = function(player)
            -- pula mais baixo
        end,
        
        atirar = function(player)
            -- atira mais devagar
        end
    }
}

-- Uso
local estadoAtual = "normal"
PlayerStates[estadoAtual].pular(player)
```

## Dicas de Uso

### 1. Não Exagera!
- Usa só quando fizer sentido
- Código simples > código complexo

### 2. Mistura os Padrões
```lua
-- Factory + Singleton
local WeaponFactory = {
    instance = nil,
    
    getInstance = function()
        if not WeaponFactory.instance then
            WeaponFactory.instance = {
                criarArma = function(tipo)
                    -- cria arma
                end
            }
        end
        return WeaponFactory.instance
    end
}
```

### 3. Adapta pra Sua Necessidade
```lua
-- Observer simplificado
local function onPlayerEnterVehicle(player, veiculo)
    -- Notifica só quem precisa
    local x, y, z = getElementPosition(veiculo)
    local jogadoresProximos = getElementsWithinRange(x, y, z, 10, "player")
    
    for _, jogador in ipairs(jogadoresProximos) do
        triggerClientEvent(jogador, "onVeiculoOcupado", veiculo)
    end
end
```

## Exemplos Práticos

### Sistema de Missões
```lua
-- State + Command
local MissaoState = {
    iniciada = {
        proximo = function(missao)
            missao.estado = MissaoState.emProgresso
            print("Missão começou!")
        end
    },
    
    emProgresso = {
        proximo = function(missao)
            if missao:checkObjetivos() then
                missao.estado = MissaoState.completa
                print("Missão completa!")
            end
        end
    },
    
    completa = {
        proximo = function(missao)
            missao:darRecompensa()
        end
    }
}
```

### Sistema de Veículos
```lua
-- Factory + Observer
local VeiculoSystem = {
    criarVeiculoEspecial = function(modelo, x, y, z)
        local veiculo = createVehicle(modelo, x, y, z)
        
        -- Observer
        addEventHandler("onVehicleDamage", veiculo, function()
            local health = getElementHealth(veiculo)
            if health < 300 then
                -- Avisa mecânicos próximos
                EventManager:notify("veiculoDanificado", veiculo)
            end
        end)
        
        return veiculo
    end
}
```

## Conclusão

Design Patterns são suas ferramentas pra:
- Código mais organizado 
- Menos bugs 
- Mais fácil de manter 

Lembra: Use com sabedoria! Nem todo código precisa de padrões complexos. 
