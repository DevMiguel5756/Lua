# Sistema de Casas MTA:SA

E aí mano! Vamo criar um sistema de casas maneiro? Aqui vai o passo a passo:

## 1. Estrutura Básica

### 1.1 Banco de Dados
Primeiro, vamo criar as tabelas:
```sql
CREATE TABLE casas (
    id INT PRIMARY KEY,
    dono VARCHAR(50),
    preco FLOAT,
    interior INT,
    trancada BOOLEAN,
    moveis TEXT
);

CREATE TABLE visitas (
    id INT PRIMARY KEY,
    casa_id INT,
    visitante VARCHAR(50),
    data TIMESTAMP
);
```

### 1.2 Funções Base
Funções principais q vamos precisar:
```lua
-- Funções da casa
function criarCasa(x, y, z, preco)
    -- Seu código aqui
end

function comprarCasa(player, casa)
    -- Seu código aqui
end

function entrarCasa(player, casa)
    -- Seu código aqui
end

function trancarCasa(player, casa)
    -- Seu código aqui
end
```

## 2. Sistema de Casa

### 2.1 Interior
Sistema de interior q:
- Carrega diferentes tipos
- Tem móveis
- Tem customização
- Salva mudanças

```lua
-- Sistema de interior
function carregarInterior(casa)
    local interior = {
        id = casa.interior,
        pos = getInteriorPos(casa.interior),
        moveis = loadMoveis(casa.id)
    }
    
    return interior
end
```

### 2.2 Móveis
Add sistema q:
- Permite comprar móveis
- Permite mover móveis
- Salva posições
- Tem diferentes tipos

```lua
-- Sistema de móveis
function addMovel(casa, tipo, x, y, z)
    local movel = {
        tipo = tipo,
        pos = {x = x, y = y, z = z},
        rot = 0
    }
    
    table.insert(casa.moveis, movel)
end
```

## 3. Features Extras

### 3.1 Sistema de Aluguel
Sistema q permite:
- Alugar casa
- Pagar aluguel
- Definir preço
- Dar despejo

```lua
-- Sistema de aluguel
function alugarCasa(player, casa, preco)
    if casa.alugada then return false end
    -- Processar aluguel
end
```

### 3.2 Sistema de Visitas
Add controle de:
- Quem pode entrar
- Horários permitidos
- Log de visitas
- Lista negra

```lua
-- Sistema de visitas
function permitirVisita(casa, visitante)
    if casa.trancada then return false end
    -- Verificar permissão
end
```

## 4. Interface

### 4.1 Menu da Casa
Interface q mostra:
- Info da casa
- Controles
- Lista de móveis
- Configurações

```lua
-- Menu da casa
function abrirMenuCasa(casa)
    local window = guiCreateWindow(0.3, 0.3, 0.4, 0.4, "Minha Casa", true)
    
    -- Info básica
    local lblInfo = guiCreateLabel(0.1, 0.1, 0.8, 0.1, 
        "Preço: $" .. casa.preco, true, window)
    
    -- Botões
    local btnTrancar = guiCreateButton(0.1, 0.8, 0.2, 0.1, 
        "Trancar", true, window)
end
```

### 4.2 Editor de Móveis
Interface pra:
- Comprar móveis
- Mover móveis
- Girar móveis
- Vender móveis

```lua
-- Editor de móveis
function abrirEditorMoveis(casa)
    local window = guiCreateWindow(0.2, 0.2, 0.6, 0.6, "Editor", true)
    
    -- Lista de móveis
    local gridMoveis = guiCreateGridList(0.05, 0.1, 0.4, 0.8, true, window)
    
    -- Preview
    local previewBox = guiCreateStaticImage(0.5, 0.1, 0.45, 0.45, 
        "preview.png", true, window)
end
```

## 5. Dicas pra Implementar

### 5.1 Planejamento
1. Comece pelo básico
2. Add features aos poucos
3. Teste bastante
4. Pegue feedback

### 5.2 Debug
1. Use prints
2. Teste colisões
3. Verifique sync
4. Corrija bugs

### 5.3 Organização
1. Comente bem
2. Separe em módulos
3. Use eventos
4. Documente tudo

## 6. Extras

### 6.1 Features Legais
- Sistema de energia
- Decorações
- Cofre
- Segurança

### 6.2 Social
- Festas
- Visitas
- Rankings
- Achievements

## 7. Próximos Passos

Depois q terminar:
1. Teste tudo
2. Otimize
3. Add features
4. Atualize sempre

Lembra:
- Teste bastante
- Sync é importante
- Backup sempre
- Divirta-se!

# Exercício: Sistema de Casas

## Objetivo
Criar um sistema completo de casas com:
- Compra e venda de casas
- Interior customizável
- Sistema de fechaduras
- Aluguel de quartos
- Armazenamento de itens

## Requisitos

### 1. Sistema Base de Casas
```lua
local HouseSystem = {
    casas = {},
    
    criarCasa = function(self, x, y, z, preco, interior)
        local casa = {
            id = #self.casas + 1,
            posicao = {x = x, y = y, z = z},
            preco = preco,
            interior = interior or 1,
            dono = nil,
            trancada = true,
            visitantes = {},
            moveis = {},
            armazenamento = {},
            aluguel = {
                preco = 0,
                inquilinos = {}
            }
        }
        
        -- Cria marker e blip
        casa.marker = createMarker(x, y, z - 1, "cylinder", 1.5,
            255, 255, 0, 100)
        casa.blip = createBlip(x, y, z, 32)
        
        -- Handler de entrada
        addEventHandler("onMarkerHit", casa.marker,
            function(hitElement)
                if getElementType(hitElement) ~= "player" then return end
                self:entrarCasa(hitElement, casa.id)
            end
        )
        
        self.casas[casa.id] = casa
        return casa.id
    end,
    
    comprarCasa = function(self, player, id)
        local casa = self.casas[id]
        if not casa then return false end
        
        if casa.dono then
            outputChatBox("Esta casa já tem dono!", player, 255, 0, 0)
            return false
        end
        
        if getPlayerMoney(player) < casa.preco then
            outputChatBox("Você não tem dinheiro suficiente!", player, 255, 0, 0)
            return false
        end
        
        -- Remove dinheiro
        takePlayerMoney(player, casa.preco)
        
        -- Define dono
        casa.dono = getPlayerAccount(player)
        
        -- Atualiza marker
        setMarkerColor(casa.marker, 0, 255, 0, 100)
        
        outputChatBox("Casa comprada com sucesso!", player, 0, 255, 0)
        return true
    end,
    
    venderCasa = function(self, player, id)
        local casa = self.casas[id]
        if not casa then return false end
        
        if casa.dono ~= getPlayerAccount(player) then
            outputChatBox("Esta casa não é sua!", player, 255, 0, 0)
            return false
        end
        
        -- Retorna dinheiro (70% do valor)
        givePlayerMoney(player, casa.preco * 0.7)
        
        -- Remove dono
        casa.dono = nil
        
        -- Reseta casa
        casa.trancada = true
        casa.visitantes = {}
        casa.moveis = {}
        casa.armazenamento = {}
        casa.aluguel.inquilinos = {}
        
        -- Atualiza marker
        setMarkerColor(casa.marker, 255, 255, 0, 100)
        
        outputChatBox("Casa vendida com sucesso!", player, 0, 255, 0)
        return true
    end,
    
    entrarCasa = function(self, player, id)
        local casa = self.casas[id]
        if not casa then return false end
        
        if casa.trancada and casa.dono ~= getPlayerAccount(player) and
           not casa.visitantes[player] and not casa.aluguel.inquilinos[player] then
            outputChatBox("Esta casa está trancada!", player, 255, 0, 0)
            return false
        end
        
        -- Teleporta para interior
        local interiors = {
            [1] = {x = 235.25, y = 1187.01, z = 1080.26},
            [2] = {x = 226.79, y = 1240.06, z = 1082.14},
            -- Adicione mais interiores
        }
        
        local pos = interiors[casa.interior]
        setElementPosition(player, pos.x, pos.y, pos.z)
        setElementInterior(player, casa.interior)
        setElementDimension(player, id)
        
        return true
    end,
    
    sairCasa = function(self, player)
        local dimension = getElementDimension(player)
        local casa = self.casas[dimension]
        if not casa then return false end
        
        -- Teleporta para entrada
        setElementPosition(player, casa.posicao.x,
            casa.posicao.y, casa.posicao.z)
        setElementInterior(player, 0)
        setElementDimension(player, 0)
        
        return true
    end,
    
    trancarCasa = function(self, player, id)
        local casa = self.casas[id]
        if not casa then return false end
        
        if casa.dono ~= getPlayerAccount(player) then
            outputChatBox("Esta casa não é sua!", player, 255, 0, 0)
            return false
        end
        
        casa.trancada = not casa.trancada
        outputChatBox("Casa " .. (casa.trancada and "trancada" or "destrancada") ..
            "!", player, 0, 255, 0)
            
        return true
    end
}
```

### 2. Sistema de Móveis
```lua
local FurnitureSystem = {
    moveis = {
        ["sofa"] = {
            modelo = 1727,
            preco = 1000,
            nome = "Sofá"
        },
        ["mesa"] = {
            modelo = 1594,
            preco = 500,
            nome = "Mesa"
        },
        -- Adicione mais móveis
    },
    
    comprarMovel = function(self, player, casa, tipo)
        local movel = self.moveis[tipo]
        if not movel then return false end
        
        if getPlayerMoney(player) < movel.preco then
            outputChatBox("Você não tem dinheiro suficiente!", player, 255, 0, 0)
            return false
        end
        
        -- Remove dinheiro
        takePlayerMoney(player, movel.preco)
        
        -- Cria móvel
        local x, y, z = getElementPosition(player)
        local objeto = createObject(movel.modelo, x, y, z)
        setElementDimension(objeto, casa.id)
        setElementInterior(objeto, casa.interior)
        
        -- Adiciona à casa
        table.insert(casa.moveis, {
            tipo = tipo,
            objeto = objeto,
            posicao = {x = x, y = y, z = z},
            rotacao = {0, 0, 0}
        })
        
        outputChatBox(movel.nome .. " comprado com sucesso!", player, 0, 255, 0)
        return true
    end,
    
    moverMovel = function(self, player, casa, index, x, y, z, rx, ry, rz)
        local movel = casa.moveis[index]
        if not movel then return false end
        
        -- Atualiza posição
        setElementPosition(movel.objeto, x, y, z)
        setElementRotation(movel.objeto, rx, ry, rz)
        
        movel.posicao = {x = x, y = y, z = z}
        movel.rotacao = {rx, ry, rz}
        
        return true
    end,
    
    venderMovel = function(self, player, casa, index)
        local movel = casa.moveis[index]
        if not movel then return false end
        
        local info = self.moveis[movel.tipo]
        
        -- Retorna dinheiro (50% do valor)
        givePlayerMoney(player, info.preco * 0.5)
        
        -- Remove móvel
        destroyElement(movel.objeto)
        table.remove(casa.moveis, index)
        
        outputChatBox(info.nome .. " vendido com sucesso!", player, 0, 255, 0)
        return true
    end
}
```

### 3. Sistema de Aluguel
```lua
local RentalSystem = {
    alugarQuarto = function(self, player, casa, preco)
        if not casa.dono then return false end
        
        if casa.dono ~= getPlayerAccount(player) then
            outputChatBox("Esta casa não é sua!", player, 255, 0, 0)
            return false
        end
        
        casa.aluguel.preco = preco
        outputChatBox("Preço do aluguel definido: $" .. preco, player, 0, 255, 0)
        return true
    end,
    
    alugar = function(self, player, casa)
        if not casa.aluguel.preco or casa.aluguel.preco <= 0 then
            outputChatBox("Esta casa não está disponível para aluguel!",
                player, 255, 0, 0)
            return false
        end
        
        if getPlayerMoney(player) < casa.aluguel.preco then
            outputChatBox("Você não tem dinheiro suficiente!", player, 255, 0, 0)
            return false
        end
        
        -- Remove dinheiro
        takePlayerMoney(player, casa.aluguel.preco)
        
        -- Adiciona inquilino
        casa.aluguel.inquilinos[player] = {
            desde = os.time(),
            ultimoPagamento = os.time()
        }
        
        outputChatBox("Quarto alugado com sucesso!", player, 0, 255, 0)
        return true
    end,
    
    cobrarAluguel = function(self)
        for _, casa in pairs(HouseSystem.casas) do
            if casa.aluguel.preco > 0 then
                for player, dados in pairs(casa.aluguel.inquilinos) do
                    if os.time() - dados.ultimoPagamento >= 24 * 60 * 60 then
                        if getPlayerMoney(player) >= casa.aluguel.preco then
                            takePlayerMoney(player, casa.aluguel.preco)
                            dados.ultimoPagamento = os.time()
                            outputChatBox("Aluguel pago: $" .. casa.aluguel.preco,
                                player, 0, 255, 0)
                        else
                            -- Remove inquilino
                            casa.aluguel.inquilinos[player] = nil
                            outputChatBox("Você foi despejado por falta de pagamento!",
                                player, 255, 0, 0)
                        end
                    end
                end
            end
        end
    end
}

-- Timer para cobrar aluguel
setTimer(function()
    RentalSystem:cobrarAluguel()
end, 60 * 60 * 1000, 0)  -- A cada hora
```

### 4. Interface Gráfica
```lua
-- Cliente
local HouseGUI = {
    window = nil,
    
    show = function(self)
        if self.window then return end
        
        -- Cria janela
        self.window = guiCreateWindow(0.3, 0.3, 0.4, 0.4,
            "Gerenciamento de Casa", true)
            
        -- Tabs
        local tabPanel = guiCreateTabPanel(0.02, 0.08, 0.96, 0.9, true,
            self.window)
            
        -- Tab Info
        local tabInfo = guiCreateTab("Informações", tabPanel)
        self:criarTabInfo(tabInfo)
        
        -- Tab Móveis
        local tabMoveis = guiCreateTab("Móveis", tabPanel)
        self:criarTabMoveis(tabMoveis)
        
        -- Tab Aluguel
        local tabAluguel = guiCreateTab("Aluguel", tabPanel)
        self:criarTabAluguel(tabAluguel)
        
        -- Mostra cursor
        showCursor(true)
    end,
    
    hide = function(self)
        if not self.window then return end
        
        destroyElement(self.window)
        self.window = nil
        
        showCursor(false)
    end,
    
    criarTabInfo = function(self, tab)
        -- Labels
        local y = 0.1
        local labels = {
            "ID: ",
            "Dono: ",
            "Preço: ",
            "Estado: ",
            "Inquilinos: "
        }
        
        for _, texto in ipairs(labels) do
            guiCreateLabel(0.1, y, 0.3, 0.1, texto, true, tab)
            y = y + 0.15
        end
        
        -- Botões
        local btnComprar = guiCreateButton(0.1, 0.8, 0.2, 0.1,
            "Comprar", true, tab)
        local btnVender = guiCreateButton(0.35, 0.8, 0.2, 0.1,
            "Vender", true, tab)
        local btnTrancar = guiCreateButton(0.6, 0.8, 0.2, 0.1,
            "Trancar", true, tab)
    end,
    
    criarTabMoveis = function(self, tab)
        -- Lista de móveis
        local gridlist = guiCreateGridList(0.05, 0.05, 0.6, 0.9, true, tab)
        
        guiGridListAddColumn(gridlist, "Nome", 0.4)
        guiGridListAddColumn(gridlist, "Preço", 0.3)
        
        -- Botões
        local btnComprar = guiCreateButton(0.7, 0.05, 0.25, 0.1,
            "Comprar", true, tab)
        local btnMover = guiCreateButton(0.7, 0.2, 0.25, 0.1,
            "Mover", true, tab)
        local btnVender = guiCreateButton(0.7, 0.35, 0.25, 0.1,
            "Vender", true, tab)
    end,
    
    criarTabAluguel = function(self, tab)
        -- Preço
        guiCreateLabel(0.1, 0.1, 0.3, 0.1, "Preço:", true, tab)
        local editPreco = guiCreateEdit(0.4, 0.1, 0.3, 0.1, "", true, tab)
        
        -- Lista de inquilinos
        local gridlist = guiCreateGridList(0.05, 0.25, 0.9, 0.6, true, tab)
        
        guiGridListAddColumn(gridlist, "Nome", 0.4)
        guiGridListAddColumn(gridlist, "Desde", 0.3)
        guiGridListAddColumn(gridlist, "Último Pagamento", 0.3)
        
        -- Botões
        local btnDefinir = guiCreateButton(0.1, 0.9, 0.2, 0.08,
            "Definir Preço", true, tab)
        local btnAlugar = guiCreateButton(0.35, 0.9, 0.2, 0.08,
            "Alugar", true, tab)
        local btnDespejar = guiCreateButton(0.6, 0.9, 0.2, 0.08,
            "Despejar", true, tab)
    end
}

-- Bind para abrir/fechar
bindKey("F6", "down",
    function()
        if HouseGUI.window then
            HouseGUI:hide()
        else
            HouseGUI:show()
        end
    end
)
