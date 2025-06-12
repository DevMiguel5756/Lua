# Guia de Segurança pra Bancos de Dados e Arquivos no MTA:SA

Fala dev! Bora aprender a deixar seus dados seguros? 

## 1. Introdução

### 1.1 Pq Segurança é Importante?
Mano, segurança é tipo a porta da sua casa. Vc n deixa ela aberta né? Então:
- Evita q os malandro mexam nos dados
- Protege as info dos players (ngm quer ter os dados vazados)
- Mantém seu server nos trinques
- Evita aquela dor de cabeça com hack

### 1.2 Oq Precisa Proteger?
1. **Dados dos Players**
   - Inventário (items, $$$, etc)
   - Stats (level, exp, kills)
   - Info pessoal (se tiver)
   - Progresso no game
   
2. **Dados do Server**
   - Configs importantes
   - Logs (pra saber qm fez oq)
   - Backups (sempre bom ter)
   - Arquivos do sistema

## 2. Protegendo o Banco de Dados

### 2.1 Criptografia (pq dados no modo easy é furada)
```lua
-- Sistema maneiro de criptografia
local SecurityUtils = {
    -- Sua chave secreta (muda isso aq, pfv!)
    encryptionKey = "sua_chave_secreta_aqui",
    
    -- Função pra criptografar dados
    encrypt = function(self, data)
        if type(data) ~= "string" then
            data = tostring(data)
        end
        
        local encrypted = ""
        for i = 1, #data do
            local byte = string.byte(data, i)
            local keyByte = string.byte(self.encryptionKey, 
                (i % #self.encryptionKey) + 1)
            encrypted = encrypted .. string.char(bit.bxor(byte, keyByte))
        end
        
        return encrypted
    end,
    
    -- Função pra descriptografar (óbvio né)
    decrypt = function(self, encrypted)
        local decrypted = ""
        for i = 1, #encrypted do
            local byte = string.byte(encrypted, i)
            local keyByte = string.byte(self.encryptionKey, 
                (i % #self.encryptionKey) + 1)
            decrypted = decrypted .. string.char(bit.bxor(byte, keyByte))
        end
        
        return decrypted
    end,
    
    -- Hash pra senha (NUNCA guarda senha em texto!)
    hashPassword = function(self, password, salt)
        salt = salt or string.random(16)
        local combined = password .. salt
        local hash = md5(combined)
        return hash, salt
    end
}
```

### 2.2 Validação de Dados (pq confiar no cliente é pedir pra ser hackado)
```lua
-- Funções pra validar dados antes de salvar
local DataValidator = {
    -- Checa se é número válido
    validateNumber = function(self, value, min, max)
        value = tonumber(value)
        if not value then return false end
        if min and value < min then return false end
        if max and value > max then return false end
        return true
    end,
    
    -- Checa se é string válida
    validateString = function(self, value, pattern, maxLength)
        if type(value) ~= "string" then return false end
        if maxLength and #value > maxLength then return false end
        if pattern and not string.match(value, pattern) then 
            return false 
        end
        return true
    end,
    
    -- Remove SQL Injection (aquele 0800)
    sanitizeSQL = function(self, value)
        if type(value) ~= "string" then return value end
        -- Remove caracteres perigosos
        value = string.gsub(value, "[';\"\\]", "")
        return value
    end
}
```

## 3. Sistema de Backup

### 3.1 Backup Automático
```lua
-- Sistema pra fazer backup dos dados
local BackupSystem = {
    config = {
        backupInterval = 3600000, -- 1 hora
        maxBackups = 24,         -- Guarda últimas 24h
        backupPath = "backups/",
        compress = true          -- Comprime pra economizar espaço
    },
    
    -- Faz backup dos dados
    backup = function(self)
        local timestamp = os.date("%Y%m%d_%H%M%S")
        local filename = self.config.backupPath .. 
            "backup_" .. timestamp .. ".sql"
            
        -- Exporta dados do DB
        local success = exportDatabaseTable(
            connection,
            filename,
            "players"  -- Nome da tabela
        )
        
        if success then
            outputDebugString("Backup feito: " .. filename)
            
            -- Remove backups antigos
            self:cleanOldBackups()
        else
            outputDebugString("Erro no backup!", 1)
        end
    end,
    
    -- Remove backups velhos
    cleanOldBackups = function(self)
        local files = {}
        local path = self.config.backupPath
        
        -- Lista arquivos
        local handle = findFirst(path .. "*.sql")
        while handle do
            table.insert(files, handle)
            handle = findNext()
        end
        
        -- Ordena por data
        table.sort(files)
        
        -- Remove mais antigos
        while #files > self.config.maxBackups do
            local oldFile = table.remove(files, 1)
            fileDelete(path .. oldFile)
        end
    end
}

-- Inicia backup automático
setTimer(function()
    BackupSystem:backup()
end, BackupSystem.config.backupInterval, 0)
```

## 4. Dicas Importantes

### 4.1 Boas Práticas
1. **Sempre valide dados do cliente**
   - N confia em nd q vem do client
   - Valida tds os inputs
   - Usa limites e regras claras

2. **Backup é vida**
   - Faz backup regular
   - Guarda em lugar seguro
   - Testa os backups

3. **Logs são seus amigos**
   - Registra td q é importante
   - Guarda logs organizados
   - Facilita achar problemas

4. **Criptografia é obrigatória**
   - Protege dados sensíveis
   - Usa algoritmos fortes
   - N inventa moda

### 4.2 Erros Comuns
1. **Confiar no Cliente**
   - Cliente pode ser hackeado
   - Sempre valide no server
   - N guarde nd importante no client

2. **Senhas em Texto**
   - NUNCA guarde senhas assim
   - Sempre use hash + salt
   - Protege os players

3. **Backup Só Qnd Der Problema**
   - Backup tem q ser automático
   - Testa recuperação
   - Mantém backups organizados

4. **Logs Fracos**
   - Log é importante
   - Guarda info útil
   - Ajuda a resolver problemas
