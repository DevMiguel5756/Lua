# Comandos e ACL no MTA:SA

## Comandos

### Criação Básica
```lua
-- Comando simples
addCommandHandler("ajuda",
    function(player, cmd)
        outputChatBox("Comandos disponíveis: /ajuda, /tp, /veiculo", player)
    end
)

-- Comando com argumentos
addCommandHandler("tp",
    function(player, cmd, x, y, z)
        if not x or not y or not z then
            outputChatBox("Uso: /tp x y z", player)
            return
        end
        
        setElementPosition(player, 
            tonumber(x), 
            tonumber(y), 
            tonumber(z)
        )
    end
)
```

### Comandos Avançados
```lua
local comandos = {
    veiculo = {
        func = function(player, args)
            local modelo = args[1] or 411
            local x, y, z = getElementPosition(player)
            createVehicle(tonumber(modelo), x + 2, y, z)
        end,
        acl = "grupo.admin",
        syntax = "/veiculo [modelo]",
        desc = "Cria um veículo"
    },
    
    vida = {
        func = function(player, args)
            local vida = args[1] or 100
            setElementHealth(player, tonumber(vida))
        end,
        acl = "grupo.moderador",
        syntax = "/vida [quantidade]",
        desc = "Define sua vida"
    }
}

-- Sistema de comandos
local function processarComando(player, cmd, ...)
    local comando = comandos[cmd]
    if not comando then return end
    
    -- Verifica permissão
    if comando.acl and not hasObjectPermissionTo(player, comando.acl) then
        outputChatBox("Sem permissão!", player, 255, 0, 0)
        return
    end
    
    -- Executa comando
    comando.func(player, {...})
end

-- Registra comandos
for nome, info in pairs(comandos) do
    addCommandHandler(nome, processarComando)
end
```

## ACL (Access Control List)

### Estrutura Básica
```lua
-- Verifica permissão
function hasPermission(player, acl)
    local account = getPlayerAccount(player)
    if not account then return false end
    
    return isObjectInACLGroup("user." .. getAccountName(account), 
        aclGetGroup(acl))
end

-- Exemplo de uso
addCommandHandler("admin",
    function(player)
        if hasPermission(player, "Admin") then
            outputChatBox("Você é admin!", player)
        else
            outputChatBox("Sem permissão!", player)
        end
    end
)
```

### Sistema de Permissões
```lua
local PermissionManager = {
    grupos = {
        admin = {
            nome = "Admin",
            permissoes = {
                "comando.veiculo",
                "comando.vida",
                "comando.kick",
                "comando.ban"
            }
        },
        moderador = {
            nome = "Moderador",
            permissoes = {
                "comando.vida",
                "comando.kick"
            }
        },
        vip = {
            nome = "VIP",
            permissoes = {
                "comando.veiculo"
            }
        }
    },
    
    hasPermission = function(self, player, permissao)
        local account = getPlayerAccount(player)
        if not account then return false end
        
        -- Verifica grupos do jogador
        for grupo, info in pairs(self.grupos) do
            if isObjectInACLGroup("user." .. getAccountName(account),
                aclGetGroup(grupo)) then
                -- Verifica se grupo tem permissão
                for _, perm in ipairs(info.permissoes) do
                    if perm == permissao then
                        return true
                    end
                end
            end
        end
        
        return false
    end,
    
    addPermission = function(self, grupo, permissao)
        if self.grupos[grupo] then
            table.insert(self.grupos[grupo].permissoes, permissao)
        end
    end,
    
    removePermission = function(self, grupo, permissao)
        if self.grupos[grupo] then
            for i, perm in ipairs(self.grupos[grupo].permissoes) do
                if perm == permissao then
                    table.remove(self.grupos[grupo].permissoes, i)
                    break
                end
            end
        end
    end
}
```

### Sistema de Comandos com ACL
```lua
local CommandManager = {
    comandos = {},
    
    registrar = function(self, nome, info)
        if type(info) ~= "table" then return end
        
        -- Valida informações
        if not info.func or type(info.func) ~= "function" then
            return false
        end
        
        -- Registra comando
        self.comandos[nome] = {
            func = info.func,
            acl = info.acl,
            syntax = info.syntax or ("/" .. nome),
            desc = info.desc or "Sem descrição"
        }
        
        -- Cria handler
        addCommandHandler(nome,
            function(player, cmd, ...)
                self:executar(player, nome, ...)
            end
        )
        
        return true
    end,
    
    executar = function(self, player, nome, ...)
        local comando = self.comandos[nome]
        if not comando then return end
        
        -- Verifica permissão
        if comando.acl and not PermissionManager:hasPermission(player, comando.acl) then
            outputChatBox("Sem permissão!", player, 255, 0, 0)
            return
        end
        
        -- Executa comando
        local success, error = pcall(comando.func, player, ...)
        if not success then
            outputDebugString("Erro no comando " .. nome .. ": " .. error)
        end
    end,
    
    ajuda = function(self, player)
        -- Lista comandos disponíveis
        outputChatBox("=== Comandos Disponíveis ===", player)
        
        for nome, info in pairs(self.comandos) do
            if not info.acl or PermissionManager:hasPermission(player, info.acl) then
                outputChatBox(info.syntax .. " - " .. info.desc, player)
            end
        end
    end
}

-- Exemplo de uso
CommandManager:registrar("veiculo", {
    func = function(player, modelo)
        local x, y, z = getElementPosition(player)
        createVehicle(tonumber(modelo or 411), x + 2, y, z)
    end,
    acl = "comando.veiculo",
    syntax = "/veiculo [modelo]",
    desc = "Cria um veículo"
})

CommandManager:registrar("ajuda", {
    func = function(player)
        CommandManager:ajuda(player)
    end,
    desc = "Mostra comandos disponíveis"
})
```

## Sistemas Práticos

### 1. Sistema de Staff
```lua
local StaffSystem = {
    niveis = {
        ["Admin"] = 3,
        ["Moderador"] = 2,
        ["Helper"] = 1
    },
    
    getNivel = function(self, player)
        local account = getPlayerAccount(player)
        if not account then return 0 end
        
        for grupo, nivel in pairs(self.niveis) do
            if isObjectInACLGroup("user." .. getAccountName(account),
                aclGetGroup(grupo)) then
                return nivel
            end
        end
        
        return 0
    end,
    
    isStaff = function(self, player)
        return self:getNivel(player) > 0
    end,
    
    canTarget = function(self, player, alvo)
        return self:getNivel(player) > self:getNivel(alvo)
    end
}

-- Exemplo de comando staff
addCommandHandler("kick",
    function(player, cmd, alvo, ...)
        if not StaffSystem:isStaff(player) then
            outputChatBox("Sem permissão!", player)
            return
        end
        
        local targetPlayer = getPlayerFromName(alvo)
        if not targetPlayer then
            outputChatBox("Jogador não encontrado!", player)
            return
        end
        
        if not StaffSystem:canTarget(player, targetPlayer) then
            outputChatBox("Você não pode kickar este jogador!", player)
            return
        end
        
        local motivo = table.concat({...}, " ") or "Sem motivo"
        kickPlayer(targetPlayer, player, motivo)
    end
)
```

### 2. Sistema de VIP
```lua
local VIPSystem = {
    beneficios = {
        ["VIP.Bronze"] = {
            veiculos = 3,
            dinheiro = 1000
        },
        ["VIP.Prata"] = {
            veiculos = 5,
            dinheiro = 2000
        },
        ["VIP.Ouro"] = {
            veiculos = 10,
            dinheiro = 5000
        }
    },
    
    getVIPLevel = function(self, player)
        local account = getPlayerAccount(player)
        if not account then return nil end
        
        for nivel in pairs(self.beneficios) do
            if isObjectInACLGroup("user." .. getAccountName(account),
                aclGetGroup(nivel)) then
                return nivel
            end
        end
        
        return nil
    end,
    
    getBeneficios = function(self, player)
        local nivel = self:getVIPLevel(player)
        return nivel and self.beneficios[nivel]
    end,
    
    aplicarBeneficios = function(self, player)
        local beneficios = self:getBeneficios(player)
        if not beneficios then return end
        
        -- Aplica benefícios
        givePlayerMoney(player, beneficios.dinheiro)
        setElementData(player, "max_veiculos", beneficios.veiculos)
    end
}

-- Handler de login
addEventHandler("onPlayerLogin", root,
    function()
        VIPSystem:aplicarBeneficios(source)
    end
)
```

### 3. Sistema de Logs
```lua
local LogSystem = {
    tipos = {
        comando = true,
        admin = true,
        chat = true
    },
    
    log = function(self, tipo, player, acao, ...)
        if not self.tipos[tipo] then return end
        
        local tempo = os.date("%Y-%m-%d %H:%M:%S")
        local nome = getPlayerName(player)
        local serial = getPlayerSerial(player)
        local ip = getPlayerIP(player)
        
        local mensagem = string.format("[%s] %s (%s | %s): %s %s",
            tempo,
            nome,
            serial,
            ip,
            acao,
            table.concat({...}, " ")
        )
        
        -- Salva log
        local arquivo = "logs/" .. tipo .. ".txt"
        local file = fileOpen(arquivo, true)
        fileWrite(file, mensagem .. "\n")
        fileClose(file)
        
        -- Debug
        outputDebugString(mensagem)
    end
}

-- Exemplo de uso
addEventHandler("onPlayerCommand", root,
    function(comando)
        LogSystem:log("comando", source, "usou comando", comando)
    end
)
```

## Dicas e Boas Práticas

### 1. Segurança
```lua
-- Sempre valide inputs
function validarInput(input)
    -- Remove caracteres perigosos
    return string.gsub(input, "[^%w%s]", "")
end

-- Use try-catch em comandos
function executarComando(player, func, ...)
    local success, error = pcall(func, player, ...)
    if not success then
        outputChatBox("Erro ao executar comando!", player)
        outputDebugString(error)
    end
end
```

### 2. Performance
```lua
-- Cache de funções comuns
local getPlayerAccount = getPlayerAccount
local isObjectInACLGroup = isObjectInACLGroup
local aclGetGroup = aclGetGroup

-- Cache de grupos ACL
local grupos = {}
function getGrupoACL(nome)
    if not grupos[nome] then
        grupos[nome] = aclGetGroup(nome)
    end
    return grupos[nome]
end
```

### 3. Organização
```lua
-- Separe comandos por categoria
local comandosAdmin = {}
local comandosMod = {}
local comandosVIP = {}

-- Use prefixos claros
addCommandHandler("a", function() end)  -- admin
addCommandHandler("m", function() end)  -- mod
addCommandHandler("v", function() end)  -- vip
```

## Exercícios

1. Crie um sistema de comandos que:
   - Registra comandos dinamicamente
   - Verifica permissões
   - Loga uso de comandos

2. Implemente um sistema ACL que:
   - Define hierarquia de grupos
   - Gerencia permissões
   - Permite herança de permissões

3. Desenvolva um sistema de staff que:
   - Define níveis de staff
   - Implementa comandos administrativos
   - Mantém logs de ações

## Conclusão

- Comandos são essenciais para interação
- ACL garante segurança
- Use sistemas organizados
- Mantenha logs
- Documente permissões
