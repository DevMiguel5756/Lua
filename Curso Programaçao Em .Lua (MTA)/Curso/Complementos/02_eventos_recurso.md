# Eventos de Recurso no MTA:SA

## O que são Eventos de Recurso?

- São eventos relacionados ao ciclo de vida de um recurso
- Permitem executar código quando o recurso inicia ou para
- Fundamentais para inicialização e limpeza de sistemas

## Eventos Principais

### onResourceStart
- Disparado quando o recurso inicia
- Usado para inicializar sistemas
- Configurar variáveis globais
- Criar elementos iniciais

```lua
addEventHandler("onResourceStart", resourceRoot,
    function()
        -- Inicialização do recurso
        print("Recurso iniciado!")
        
        -- Criar elementos
        criarVeiculosIniciais()
        
        -- Carregar dados
        carregarDadosSalvos()
    end
)
```

### onResourceStop
- Disparado quando o recurso para
- Usado para limpar sistemas
- Salvar dados
- Destruir elementos

```lua
addEventHandler("onResourceStop", resourceRoot,
    function()
        -- Salvar dados
        salvarDadosJogadores()
        
        -- Limpar elementos
        destruirElementos()
    end
)
```

## Eventos Cliente vs Servidor

### Servidor
- `onResourceStart`
- `onResourceStop`
- Acesso a todos os jogadores
- Manipulação de dados globais

### Cliente
- `onClientResourceStart`
- `onClientResourceStop`
- Interface gráfica
- Efeitos visuais/sonoros

```lua
-- Servidor
addEventHandler("onResourceStart", resourceRoot,
    function()
        -- Código servidor
    end
)

-- Cliente
addEventHandler("onClientResourceStart", resourceRoot,
    function()
        -- Código cliente
    end
)
```

## Boas Práticas

### 1. Estrutura de Inicialização
```lua
local function inicializarSistemas()
    -- Sistema 1
    iniciarSistema1()
    
    -- Sistema 2
    iniciarSistema2()
end

local function iniciarSistema1()
    -- Implementação
end

addEventHandler("onResourceStart", resourceRoot,
    function()
        inicializarSistemas()
    end
)
```

### 2. Limpeza de Recursos
```lua
local elementosCriados = {}

local function criarElemento(tipo, x, y, z)
    local elemento = createElement(tipo, x, y, z)
    table.insert(elementosCriados, elemento)
    return elemento
end

local function limparElementos()
    for _, elemento in ipairs(elementosCriados) do
        if isElement(elemento) then
            destroyElement(elemento)
        end
    end
end

addEventHandler("onResourceStop", resourceRoot,
    function()
        limparElementos()
    end
)
```

### 3. Salvamento de Dados
```lua
local function salvarDados()
    for _, player in ipairs(getElementsByType("player")) do
        -- Salva dados do jogador
        local dinheiro = getPlayerMoney(player)
        local vida = getElementHealth(player)
        
        -- Salva em XML
        local conta = getPlayerAccount(player)
        if conta then
            setAccountData(conta, "dinheiro", dinheiro)
            setAccountData(conta, "vida", vida)
        end
    end
end

addEventHandler("onResourceStop", resourceRoot,
    function()
        salvarDados()
    end
)
```

## Exemplos Práticos

### 1. Sistema de Spawn
```lua
local spawns = {
    {x = 0, y = 0, z = 3},
    {x = 10, y = 0, z = 3},
    -- Adicione mais spawns
}

addEventHandler("onResourceStart", resourceRoot,
    function()
        -- Cria spawnpoints
        for _, spawn in ipairs(spawns) do
            createMarker(spawn.x, spawn.y, spawn.z, "cylinder")
        end
        
        -- Spawna jogadores
        for _, player in ipairs(getElementsByType("player")) do
            spawnPlayer(player, unpack(spawns[1]))
        end
    end
)
```

### 2. Sistema de Veículos
```lua
local veiculos = {
    {modelo = 411, x = 0, y = 5, z = 3},
    {modelo = 522, x = 5, y = 5, z = 3},
    -- Adicione mais veículos
}

local veiculosCriados = {}

addEventHandler("onResourceStart", resourceRoot,
    function()
        -- Cria veículos
        for _, v in ipairs(veiculos) do
            local veiculo = createVehicle(v.modelo, v.x, v.y, v.z)
            table.insert(veiculosCriados, veiculo)
        end
    end
)

addEventHandler("onResourceStop", resourceRoot,
    function()
        -- Destroi veículos
        for _, veiculo in ipairs(veiculosCriados) do
            if isElement(veiculo) then
                destroyElement(veiculo)
            end
        end
    end
)
```

### 3. Sistema de Dados
```lua
local function carregarDados()
    for _, player in ipairs(getElementsByType("player")) do
        local conta = getPlayerAccount(player)
        if conta then
            -- Carrega dados
            local dinheiro = getAccountData(conta, "dinheiro") or 0
            local vida = getAccountData(conta, "vida") or 100
            
            -- Aplica dados
            setPlayerMoney(player, dinheiro)
            setElementHealth(player, vida)
        end
    end
end

local function salvarDados()
    for _, player in ipairs(getElementsByType("player")) do
        local conta = getPlayerAccount(player)
        if conta then
            -- Salva dados
            setAccountData(conta, "dinheiro", getPlayerMoney(player))
            setAccountData(conta, "vida", getElementHealth(player))
        end
    end
end

addEventHandler("onResourceStart", resourceRoot,
    function()
        carregarDados()
    end
)

addEventHandler("onResourceStop", resourceRoot,
    function()
        salvarDados()
    end
)
```

## Dicas Avançadas

### 1. Dependências entre Recursos
```lua
addEventHandler("onResourceStart", resourceRoot,
    function()
        -- Verifica dependências
        local recursos = {
            "recurso1",
            "recurso2"
        }
        
        for _, recurso in ipairs(recursos) do
            if not getResourceFromName(recurso) then
                cancelEvent()
                outputDebugString("Dependência faltando: " .. recurso)
                return
            end
        end
    end
)
```

### 2. Reinicialização Segura
```lua
local sistemasIniciados = {}

local function iniciarSistema(nome)
    if not sistemasIniciados[nome] then
        -- Inicia sistema
        sistemasIniciados[nome] = true
        return true
    end
    return false
end

local function pararSistema(nome)
    if sistemasIniciados[nome] then
        -- Para sistema
        sistemasIniciados[nome] = false
        return true
    end
    return false
end

addEventHandler("onResourceStart", resourceRoot,
    function()
        iniciarSistema("sistema1")
        iniciarSistema("sistema2")
    end
)

addEventHandler("onResourceStop", resourceRoot,
    function()
        pararSistema("sistema2")
        pararSistema("sistema1")
    end
)
```

### 3. Debug e Logging
```lua
local debug = true

local function log(mensagem)
    if debug then
        outputDebugString("[Recurso] " .. mensagem)
    end
end

addEventHandler("onResourceStart", resourceRoot,
    function()
        log("Recurso iniciando...")
        
        -- Código de inicialização
        
        log("Recurso iniciado com sucesso!")
    end
)
```

## Exercícios Práticos

1. Crie um sistema que salva a posição dos jogadores quando o recurso para e os coloca de volta quando reinicia

2. Implemente um sistema de veículos que:
   - Cria veículos quando o recurso inicia
   - Salva o estado dos veículos (dano, tuning) quando para
   - Restaura o estado quando reinicia

3. Desenvolva um sistema de elementos que:
   - Mantém registro de todos os elementos criados
   - Limpa corretamente quando o recurso para
   - Previne memory leaks

## Conclusão

- Eventos de recurso são fundamentais para:
  - Inicialização correta de sistemas
  - Limpeza adequada de recursos
  - Salvamento de dados
  - Gerenciamento de elementos

- Boas práticas incluem:
  - Estruturação clara do código
  - Limpeza adequada de recursos
  - Tratamento de erros
  - Logging e debug
