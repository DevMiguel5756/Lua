# Funções de Interface no MTA:SA

## GUI Básico

### 1. Janelas
```lua
-- Criar janela
local window = guiCreateWindow(x, y, width, height, 
    "Título", relative)

-- Propriedades
guiWindowSetSizable(window, false)
guiWindowSetMovable(window, true)
```

### 2. Botões
```lua
-- Criar botão
local button = guiCreateButton(x, y, width, height,
    "Texto", relative, parent)

-- Eventos
addEventHandler("onClientGUIClick", button,
    function()
        -- Ação do botão
    end, false
)
```

### 3. Campos de Texto
```lua
-- Criar edit box
local edit = guiCreateEdit(x, y, width, height,
    "Texto padrão", relative, parent)

-- Manipular texto
local texto = guiGetText(edit)
guiSetText(edit, "Novo texto")
```

## Elementos Avançados

### 1. GridList
```lua
-- Criar grid
local grid = guiCreateGridList(x, y, width, height,
    relative, parent)

-- Adicionar colunas
local col1 = guiGridListAddColumn(grid, "Nome", 0.4)
local col2 = guiGridListAddColumn(grid, "Pontos", 0.3)

-- Adicionar linhas
local row = guiGridListAddRow(grid)
guiGridListSetItemText(grid, row, col1, "João", false, false)
guiGridListSetItemText(grid, row, col2, "100", false, false)
```

### 2. TabPanel
```lua
-- Criar tab panel
local tabPanel = guiCreateTabPanel(x, y, width, height,
    relative, parent)

-- Adicionar tabs
local tab1 = guiCreateTab("Geral", tabPanel)
local tab2 = guiCreateTab("Configurações", tabPanel)
```

### 3. Memo
```lua
-- Criar memo
local memo = guiCreateMemo(x, y, width, height,
    "Texto inicial", relative, parent)

-- Manipular texto
guiSetText(memo, "Novo texto\nCom múltiplas linhas")
local texto = guiGetText(memo)
```

## DX Drawing

### 1. Texto
```lua
addEventHandler("onClientRender", root,
    function()
        dxDrawText("Texto na tela",
            x, y, endX, endY,
            tocolor(255, 255, 255, 255),
            1.0, "default",
            "left", "top",
            false, false, true)
    end
)
```

### 2. Retângulos
```lua
addEventHandler("onClientRender", root,
    function()
        dxDrawRectangle(x, y, width, height,
            tocolor(255, 0, 0, 200),
            true)
    end
)
```

### 3. Imagens
```lua
-- Carregar textura
local textura = dxCreateTexture("imagem.png")

-- Renderizar
addEventHandler("onClientRender", root,
    function()
        dxDrawImage(x, y, width, height,
            textura,
            0, 0, 0,
            tocolor(255, 255, 255, 255),
            true)
    end
)
```

## Exemplos Práticos

### 1. Menu Principal
```lua
local gui = {
    window = nil,
    buttons = {}
}

function criarMenuPrincipal()
    gui.window = guiCreateWindow(0.3, 0.3, 0.4, 0.4,
        "Menu Principal", true)
    
    local y = 0.1
    local opcoes = {
        {"Jogar", iniciarJogo},
        {"Configurações", abrirConfig},
        {"Sair", fecharMenu}
    }
    
    for i, opcao in ipairs(opcoes) do
        local btn = guiCreateButton(0.1, y, 0.8, 0.1,
            opcao[1], true, gui.window)
            
        addEventHandler("onClientGUIClick", btn,
            function()
                opcao[2]()
            end, false
        )
        
        gui.buttons[opcao[1]] = btn
        y = y + 0.15
    end
    
    guiSetVisible(gui.window, false)
    showCursor(false)
end
```

### 2. HUD Personalizado
```lua
local screenW, screenH = guiGetScreenSize()
local vida = 100
local colete = 100
local dinheiro = 1000

addEventHandler("onClientRender", root,
    function()
        -- Background
        dxDrawRectangle(10, 10, 200, 100,
            tocolor(0, 0, 0, 150))
            
        -- Vida
        dxDrawRectangle(20, 20, vida * 1.8, 20,
            tocolor(255, 0, 0, 200))
        dxDrawText("Vida: " .. vida,
            20, 20, 200, 40,
            tocolor(255, 255, 255),
            1.2, "default")
            
        -- Colete
        dxDrawRectangle(20, 50, colete * 1.8, 20,
            tocolor(0, 0, 255, 200))
        dxDrawText("Colete: " .. colete,
            20, 50, 200, 70,
            tocolor(255, 255, 255),
            1.2, "default")
            
        -- Dinheiro
        dxDrawText("$" .. dinheiro,
            20, 80, 200, 100,
            tocolor(0, 255, 0),
            1.5, "default-bold")
    end
)
```

### 3. Sistema de Inventário
```lua
local inventario = {
    window = nil,
    grid = nil,
    items = {}
}

function criarInventario()
    inventario.window = guiCreateWindow(0.7, 0.2, 0.25, 0.6,
        "Inventário", true)
        
    inventario.grid = guiCreateGridList(0.05, 0.1, 0.9, 0.8,
        true, inventario.window)
        
    local colNome = guiGridListAddColumn(inventario.grid,
        "Item", 0.6)
    local colQuant = guiGridListAddColumn(inventario.grid,
        "Qtd", 0.3)
        
    -- Botões
    local btnUsar = guiCreateButton(0.05, 0.9, 0.4, 0.08,
        "Usar", true, inventario.window)
    local btnDropar = guiCreateButton(0.55, 0.9, 0.4, 0.08,
        "Dropar", true, inventario.window)
        
    addEventHandler("onClientGUIClick", btnUsar,
        function()
            local item = getSelectedItem()
            if item then
                usarItem(item)
            end
        end, false
    )
    
    guiSetVisible(inventario.window, false)
end

function atualizarInventario()
    guiGridListClear(inventario.grid)
    
    for item, quantidade in pairs(inventario.items) do
        local row = guiGridListAddRow(inventario.grid)
        guiGridListSetItemText(inventario.grid, row, 1,
            item, false, false)
        guiGridListSetItemText(inventario.grid, row, 2,
            tostring(quantidade), false, false)
    end
end
```

## Boas Práticas

### 1. Performance
```lua
-- Cache de texturas
local texturas = {}
function carregarTextura(path)
    if not texturas[path] then
        texturas[path] = dxCreateTexture(path)
    end
    return texturas[path]
end

-- Limitar updates
local lastUpdate = 0
addEventHandler("onClientRender", root,
    function()
        local now = getTickCount()
        if now - lastUpdate < 50 then return end
        lastUpdate = now
        
        -- Renderização pesada aqui
    end
)
```

### 2. Organização
```lua
-- Separar GUI por sistemas
local sistemas = {
    inventario = {},
    loja = {},
    configuracoes = {}
}

-- Funções de utilidade
function mostrarJanela(janela)
    for _, sistema in pairs(sistemas) do
        if sistema.window then
            guiSetVisible(sistema.window, false)
        end
    end
    
    if janela then
        guiSetVisible(janela, true)
        guiBringToFront(janela)
    end
    
    showCursor(janela ~= nil)
end
```

### 3. Responsividade
```lua
local screenW, screenH = guiGetScreenSize()

function calcularPosicao(percentX, percentY)
    return screenW * percentX, screenH * percentY
end

function calcularTamanho(percentW, percentH)
    return screenW * percentW, screenH * percentH
end
```

## Conclusão

Funções de interface são essenciais para:
- Criar menus e HUDs
- Interação com usuário
- Feedback visual
- Experiência de jogo melhorada
