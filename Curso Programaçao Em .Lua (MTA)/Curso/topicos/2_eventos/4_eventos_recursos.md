# Eventos de Recursos no MTA:SA

## Introdução

Os eventos de recursos são fundamentais para controlar o ciclo de vida dos recursos no MTA:SA. Eles permitem que você execute código quando um recurso é iniciado, parado ou quando ocorrem outras mudanças importantes.

## Eventos Principais

### 1. onResourceStart
```lua
addEventHandler("onResourceStart", resourceRoot,
    function(startedResource)
        outputChatBox("Recurso iniciado: " .. getResourceName(startedResource))
        -- Inicialização do recurso
        -- Carregar dados
        -- Criar elementos
    end
)
```

### 2. onResourceStop
```lua
addEventHandler("onResourceStop", resourceRoot,
    function(stoppedResource)
        outputChatBox("Recurso parado: " .. getResourceName(stoppedResource))
        -- Salvar dados
        -- Limpar elementos
        -- Fazer cleanup
    end
)
```

### 3. onResourcePreStart
```lua
addEventHandler("onResourcePreStart", root,
    function(resource)
        -- Executado antes do recurso iniciar
        -- Útil para verificações preliminares
    end
)
```

## Elementos Root

### 1. resourceRoot
```lua
-- Elemento raiz do recurso atual
addEventHandler("onResourceStart", resourceRoot,
    function()
        -- Afeta apenas o recurso atual
    end
)
```

### 2. root
```lua
-- Elemento raiz global
addEventHandler("onResourceStart", root,
    function(resource)
        -- Afeta todos os recursos
    end
)
```

## Práticas Comuns

### 1. Inicialização de Dados
```lua
local function inicializarDados()
    -- Criar tabelas
    jogadores = {}
    veiculos = {}
    
    -- Carregar do banco de dados
    carregarDadosSalvos()
end

addEventHandler("onResourceStart", resourceRoot, inicializarDados)
```

### 2. Salvamento de Dados
```lua
local function salvarDados()
    -- Salvar no banco de dados
    for id, dados in pairs(jogadores) do
        salvarDadosJogador(id, dados)
    end
end

addEventHandler("onResourceStop", resourceRoot, salvarDados)
```

### 3. Limpeza de Elementos
```lua
local function limparElementos()
    -- Destruir elementos criados
    for _, veiculo in ipairs(getElementsByType("vehicle")) do
        if getElementData(veiculo, "pertence_ao_recurso") then
            destroyElement(veiculo)
        end
    end
end

addEventHandler("onResourceStop", resourceRoot, limparElementos)
```

## Dependências entre Recursos

### 1. Verificar Dependências
```lua
addEventHandler("onResourcePreStart", resourceRoot,
    function()
        local recursos_necessarios = {
            "banco_dados",
            "sistema_login"
        }
        
        for _, recurso in ipairs(recursos_necessarios) do
            if not getResourceFromName(recurso) then
                cancelEvent(true, "Recurso necessário não encontrado: " .. recurso)
                return
            end
        end
    end
)
```

### 2. Comunicação entre Recursos
```lua
addEventHandler("onResourceStart", resourceRoot,
    function()
        local outro_recurso = getResourceFromName("outro_recurso")
        if outro_recurso then
            exports["outro_recurso"]:funcaoExportada()
        end
    end
)
```

## Eventos Personalizados

### 1. Criar Evento
```lua
addEvent("onRecursoPreparado", true)

addEventHandler("onResourceStart", resourceRoot,
    function()
        -- Preparar recurso
        triggerEvent("onRecursoPreparado", resourceRoot)
    end
)
```

### 2. Responder ao Evento
```lua
addEventHandler("onRecursoPreparado", resourceRoot,
    function()
        -- Executar código após preparação
    end
)
```

## Exercícios

1. Sistema de Backup:
   - Crie um sistema que salva dados periodicamente
   - Use onResourceStop para backup final
   - Implemente recuperação no onResourceStart

2. Gerenciamento de Elementos:
   - Crie elementos no início do recurso
   - Mantenha registro dos elementos criados
   - Limpe corretamente ao parar

3. Dependências:
   - Crie sistema com múltiplos recursos
   - Gerencie ordem de inicialização
   - Implemente comunicação entre recursos

## Dicas e Boas Práticas

1. **Sempre Limpe Recursos**
   - Destrua elementos criados
   - Feche conexões de banco
   - Limpe timers

2. **Gerencie Dependências**
   - Verifique recursos necessários
   - Use exports com cuidado
   - Documente dependências

3. **Debug e Logs**
   - Use outputDebugString
   - Registre erros importantes
   - Monitore uso de memória

## Conclusão

Eventos de recursos são cruciais para:
- Inicialização adequada
- Limpeza de recursos
- Gerenciamento de dependências
- Manutenção da integridade do servidor
