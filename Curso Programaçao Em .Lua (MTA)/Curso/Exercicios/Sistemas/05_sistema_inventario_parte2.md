# Sistema de Inventário MTA:SA - Parte 2

E aí mano! Vamo continuar nosso sistema de inventário? Aqui vai a segunda parte:

## 1. Sistema de Transferência

### 1.1 Entre Jogadores
Sistema pra:
- Trocar itens
- Dar itens
- Vender itens
- Negociar

```lua
-- Sistema de troca
function iniciarTroca(player1, player2)
    local troca = {
        player1 = {itens = {}, dinheiro = 0},
        player2 = {itens = {}, dinheiro = 0},
        status = "pendente"
    }
    
    return troca
end
```

### 1.2 Com Containers
Add sistema q:
- Usa baús
- Tem cofres
- Tem lixeiras
- Salva itens

```lua
-- Sistema de container
function abrirContainer(player, container)
    if container.trancado then return false end
    -- Abrir container
end
```

## 2. Sistema de Crafting

### 2.1 Receitas
Sistema q:
- Define receitas
- Checa materiais
- Cria novos itens
- Dá experiência

```lua
-- Sistema de craft
local receitas = {
    medkit = {
        materiais = {
            bandagem = 2,
            alcool = 1
        },
        resultado = "medkit",
        quantidade = 1
    }
}
```

### 2.2 Workbench
Add sistema q:
- Tem níveis
- Tem categorias
- Tem tempo
- Tem qualidade

```lua
-- Sistema de workbench
function craftarItem(player, receita, bench)
    if not temMateriais(player, receita) then return false end
    -- Craftar item
end
```

## 3. Sistema de Durabilidade

### 3.1 Desgaste
Sistema q:
- Reduz durabilidade
- Quebra itens
- Permite reparo
- Tem custos

```lua
-- Sistema de desgaste
function usarDurabilidade(item, valor)
    item.durabilidade = item.durabilidade - valor
    if item.durabilidade <= 0 then
        quebrarItem(item)
    end
end
```

### 3.2 Reparo
Add sistema q:
- Repara itens
- Usa materiais
- Tem custo
- Tem chance

```lua
-- Sistema de reparo
function repararItem(player, item)
    if not item.quebravel then return false end
    -- Reparar item
end
```

## 4. Interface Avançada

### 4.1 Drag and Drop
Interface q:
- Move itens
- Divide stacks
- Junta itens
- Usa atalhos

```lua
-- Sistema de drag
function onClientDragItem(slot1, slot2)
    local item1 = getSlotItem(slot1)
    local item2 = getSlotItem(slot2)
    
    -- Processar movimento
end
```

### 4.2 Filtros e Busca
Add sistema q:
- Filtra tipos
- Busca itens
- Ordena slots
- Mostra stats

```lua
-- Sistema de filtro
function filtrarItens(inv, filtro)
    local resultado = {}
    
    for slot, item in pairs(inv.itens) do
        if matchFiltro(item, filtro) then
            table.insert(resultado, item)
        end
    end
    
    return resultado
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
2. Teste trocas
3. Verifique craft
4. Corrija bugs

### 5.3 Organização
1. Comente bem
2. Separe em módulos
3. Use eventos
4. Documente tudo

## 6. Extras

### 6.1 Features Legais
- Sets de item
- Encantamentos
- Quests
- Trading

### 6.2 Economia
- Leilão
- Mercado
- Preços
- Inflação

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

# Exercício: Sistema de Inventário - Parte 2

## Objetivo
Implementar funcionalidades avançadas do sistema de inventário:
- Uso de itens
- Transferência entre jogadores
- Interface gráfica
- Sistema de crafting
- Sistema de loot

## Requisitos

### 1. Sistema de Uso de Itens
```lua
local ItemUseSystem = {
    usarItem = function(self, player, slot)
        local inv = InventorySystem:getInventario(player)
        if not inv then return false end
        
        local item = inv.slots[slot]
        if not item then return false end
        
        local itemInfo = ItemSystem:getItem(item.id)
        if not itemInfo or not itemInfo.usavel then
            return false, "Item não pode ser usado"
        end
        
        -- Usa item
        local sucesso, mensagem = itemInfo.aoUsar(player)
        if not sucesso then
            return false, mensagem
        end
        
        -- Remove uma unidade
        item.quantidade = item.quantidade - 1
        item.peso = itemInfo.peso * item.quantidade
        
        inv.pesoAtual = inv.pesoAtual - itemInfo.peso
        
        if item.quantidade <= 0 then
            inv.slots[slot] = nil
        end
        
        return true
    end,
    
    equiparItem = function(self, player, slot)
        local inv = InventorySystem:getInventario(player)
        if not inv then return false end
        
        local item = inv.slots[slot]
        if not item then return false end
        
        local itemInfo = ItemSystem:getItem(item.id)
        if not itemInfo or not itemInfo.equipavel then
            return false, "Item não pode ser equipado"
        end
        
        -- Remove item equipado atual
        local slotEquipado = itemInfo.slotEquip
        if inv.equipado[slotEquipado] then
            local itemAntigo = inv.equipado[slotEquipado]
            if not InventorySystem:addItem(player, itemAntigo.id, itemAntigo.quantidade) then
                return false, "Inventário cheio"
            end
        end
        
        -- Equipa novo item
        inv.equipado[slotEquipado] = item
        inv.slots[slot] = nil
        
        -- Aplica efeitos
        if itemInfo.aoEquipar then
            itemInfo.aoEquipar(player)
        end
        
        return true
    end,
    
    desequiparItem = function(self, player, slot)
        local inv = InventorySystem:getInventario(player)
        if not inv then return false end
        
        local item = inv.equipado[slot]
        if not item then return false end
        
        -- Remove efeitos
        local itemInfo = ItemSystem:getItem(item.id)
        if itemInfo.aoDesequipar then
            itemInfo.aoDesequipar(player)
        end
        
        -- Volta para inventário
        if not InventorySystem:addItem(player, item.id, item.quantidade) then
            return false, "Inventário cheio"
        end
        
        inv.equipado[slot] = nil
        return true
    end
}

### 2. Sistema de Transferência
```lua
local TransferSystem = {
    transferirItem = function(self, origem, destino, slot, quantidade)
        local invOrigem = InventorySystem:getInventario(origem)
        local invDestino = InventorySystem:getInventario(destino)
        
        if not invOrigem or not invDestino then
            return false, "Inventário inválido"
        end
        
        local item = invOrigem.slots[slot]
        if not item then return false, "Item não encontrado" end
        
        quantidade = quantidade or item.quantidade
        if quantidade > item.quantidade then
            return false, "Quantidade inválida"
        end
        
        -- Verifica distância
        local x1, y1, z1 = getElementPosition(origem)
        local x2, y2, z2 = getElementPosition(destino)
        
        if getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) > 3 then
            return false, "Muito longe"
        end
        
        -- Transfere item
        local itemInfo = ItemSystem:getItem(item.id)
        local pesoTransferencia = itemInfo.peso * quantidade
        
        if invDestino.pesoAtual + pesoTransferencia > invDestino.pesoMax then
            return false, "Inventário destino cheio"
        end
        
        if not InventorySystem:addItem(destino, item.id, quantidade) then
            return false, "Erro ao transferir"
        end
        
        -- Remove do origem
        item.quantidade = item.quantidade - quantidade
        item.peso = itemInfo.peso * item.quantidade
        
        invOrigem.pesoAtual = invOrigem.pesoAtual - pesoTransferencia
        
        if item.quantidade <= 0 then
            invOrigem.slots[slot] = nil
        end
        
        return true
    end,
    
    droparItem = function(self, player, slot, quantidade)
        local inv = InventorySystem:getInventario(player)
        if not inv then return false end
        
        local item = inv.slots[slot]
        if not item then return false end
        
        quantidade = quantidade or item.quantidade
        if quantidade > item.quantidade then
            return false, "Quantidade inválida"
        end
        
        -- Cria pickup
        local x, y, z = getElementPosition(player)
        local pickup = createPickup(x, y, z, 3, 1254)
        
        setElementData(pickup, "item", {
            id = item.id,
            quantidade = quantidade
        })
        
        -- Remove do inventário
        local itemInfo = ItemSystem:getItem(item.id)
        item.quantidade = item.quantidade - quantidade
        item.peso = itemInfo.peso * item.quantidade
        
        inv.pesoAtual = inv.pesoAtual - (itemInfo.peso * quantidade)
        
        if item.quantidade <= 0 then
            inv.slots[slot] = nil
        end
        
        return true
    end,
    
    coletarItem = function(self, player, pickup)
        local itemData = getElementData(pickup, "item")
        if not itemData then return false end
        
        if InventorySystem:addItem(player, itemData.id, itemData.quantidade) then
            destroyElement(pickup)
            return true
        end
        
        return false, "Inventário cheio"
    end
}

-- Handler de pickup
addEventHandler("onPickupHit", root,
    function(player)
        if getElementType(player) ~= "player" then return end
        
        TransferSystem:coletarItem(player, source)
    end
)

### 3. Sistema de Crafting
```lua
local CraftingSystem = {
    receitas = {
        ["medkit"] = {
            ingredientes = {
                ["bandagem"] = 2,
                ["alcool"] = 1
            },
            resultado = {
                id = "medkit",
                quantidade = 1
            },
            nivel = 1,
            tempo = 5000  -- 5 segundos
        },
        ["colete_basico"] = {
            ingredientes = {
                ["tecido"] = 3,
                ["metal"] = 2
            },
            resultado = {
                id = "colete",
                quantidade = 1
            },
            nivel = 2,
            tempo = 10000
        }
        -- Adicione mais receitas
    },
    
    craftingAtivo = {},
    
    iniciarCrafting = function(self, player, receita)
        if self.craftingAtivo[player] then
            return false, "Já está craftando"
        end
        
        local receitaInfo = self.receitas[receita]
        if not receitaInfo then return false end
        
        -- Verifica ingredientes
        for item, quantidade in pairs(receitaInfo.ingredientes) do
            if InventorySystem:getQuantidadeItem(player, item) < quantidade then
                return false, "Ingredientes insuficientes"
            end
        end
        
        -- Remove ingredientes
        for item, quantidade in pairs(receitaInfo.ingredientes) do
            self:removerIngredientes(player, item, quantidade)
        end
        
        -- Inicia crafting
        self.craftingAtivo[player] = {
            receita = receita,
            inicio = getTickCount(),
            timer = setTimer(
                function()
                    self:finalizarCrafting(player)
                end,
                receitaInfo.tempo,
                1
            )
        }
        
        return true
    end,
    
    finalizarCrafting = function(self, player)
        local crafting = self.craftingAtivo[player]
        if not crafting then return false end
        
        local receitaInfo = self.receitas[crafting.receita]
        
        -- Adiciona resultado
        InventorySystem:addItem(player,
            receitaInfo.resultado.id,
            receitaInfo.resultado.quantidade
        )
        
        -- Limpa crafting
        if isTimer(crafting.timer) then
            killTimer(crafting.timer)
        end
        
        self.craftingAtivo[player] = nil
        return true
    end,
    
    cancelarCrafting = function(self, player)
        local crafting = self.craftingAtivo[player]
        if not crafting then return false end
        
        -- Devolve ingredientes
        local receitaInfo = self.receitas[crafting.receita]
        for item, quantidade in pairs(receitaInfo.ingredientes) do
            InventorySystem:addItem(player, item, quantidade)
        end
        
        -- Limpa crafting
        if isTimer(crafting.timer) then
            killTimer(crafting.timer)
        end
        
        self.craftingAtivo[player] = nil
        return true
    end,
    
    removerIngredientes = function(self, player, item, quantidade)
        local inv = InventorySystem:getInventario(player)
        if not inv then return false end
        
        local restante = quantidade
        
        for slot, itemSlot in pairs(inv.slots) do
            if itemSlot.id == item then
                local remover = math.min(restante, itemSlot.quantidade)
                
                itemSlot.quantidade = itemSlot.quantidade - remover
                itemSlot.peso = ItemSystem:getItem(item).peso * itemSlot.quantidade
                
                inv.pesoAtual = inv.pesoAtual -
                    (ItemSystem:getItem(item).peso * remover)
                
                if itemSlot.quantidade <= 0 then
                    inv.slots[slot] = nil
                end
                
                restante = restante - remover
                if restante <= 0 then break end
            end
        end
        
        return true
    end
}

### 4. Interface Gráfica
```lua
-- Cliente
local InventoryGUI = {
    window = nil,
    slots = {},
    
    show = function(self)
        if self.window then return end
        
        -- Cria janela
        self.window = guiCreateWindow(0.3, 0.2, 0.4, 0.6,
            "Inventário", true)
            
        -- Tabs
        local tabPanel = guiCreateTabPanel(0.02, 0.08, 0.96, 0.9, true,
            self.window)
            
        -- Tab Inventário
        local tabInv = guiCreateTab("Inventário", tabPanel)
        self:criarTabInventario(tabInv)
        
        -- Tab Equipado
        local tabEquip = guiCreateTab("Equipado", tabPanel)
        self:criarTabEquipado(tabEquip)
        
        -- Tab Crafting
        local tabCraft = guiCreateTab("Crafting", tabPanel)
        self:criarTabCrafting(tabCraft)
        
        -- Mostra cursor
        showCursor(true)
        
        -- Atualiza interface
        self:atualizarInterface()
    end,
    
    hide = function(self)
        if not self.window then return end
        
        destroyElement(self.window)
        self.window = nil
        self.slots = {}
        
        showCursor(false)
    end,
    
    criarTabInventario = function(self, tab)
        -- Grid de slots
        local slotSize = 0.1
        local margin = 0.01
        local cols = 5
        
        for i = 1, 20 do
            local row = math.floor((i-1) / cols)
            local col = (i-1) % cols
            
            local x = margin + col * (slotSize + margin)
            local y = margin + row * (slotSize + margin)
            
            local slot = guiCreateStaticImage(x, y, slotSize, slotSize,
                "images/slot.png", true, tab)
                
            self.slots[i] = {
                background = slot,
                imagem = nil,
                quantidade = nil
            }
        end
        
        -- Info do item
        local infoPanel = guiCreateScrollPane(0.65, 0.05, 0.3, 0.9, true, tab)
        
        -- Peso
        local labelPeso = guiCreateLabel(0.65, 0.95, 0.3, 0.05,
            "Peso: 0/50", true, tab)
    end,
    
    criarTabEquipado = function(self, tab)
        -- Slots de equipamento
        local slots = {
            ["cabeca"] = {x = 0.4, y = 0.1},
            ["torso"] = {x = 0.4, y = 0.3},
            ["maos"] = {x = 0.2, y = 0.3},
            ["pernas"] = {x = 0.4, y = 0.5},
            ["pes"] = {x = 0.4, y = 0.7},
            ["costas"] = {x = 0.6, y = 0.3},
            ["arma1"] = {x = 0.2, y = 0.1},
            ["arma2"] = {x = 0.6, y = 0.1}
        }
        
        for slot, pos in pairs(slots) do
            local background = guiCreateStaticImage(pos.x, pos.y, 0.1, 0.1,
                "images/slot_" .. slot .. ".png", true, tab)
                
            self.slots[slot] = {
                background = background,
                imagem = nil,
                quantidade = nil
            }
        end
    end,
    
    criarTabCrafting = function(self, tab)
        -- Lista de receitas
        local gridlist = guiCreateGridList(0.05, 0.05, 0.4, 0.9, true, tab)
        
        guiGridListAddColumn(gridlist, "Receita", 0.6)
        guiGridListAddColumn(gridlist, "Nível", 0.2)
        guiGridListAddColumn(gridlist, "Tempo", 0.2)
        
        -- Ingredientes
        local labelIng = guiCreateLabel(0.5, 0.05, 0.45, 0.05,
            "Ingredientes:", true, tab)
        local gridIng = guiCreateGridList(0.5, 0.1, 0.45, 0.4, true, tab)
        
        guiGridListAddColumn(gridIng, "Item", 0.7)
        guiGridListAddColumn(gridIng, "Qtd", 0.3)
        
        -- Resultado
        local labelRes = guiCreateLabel(0.5, 0.55, 0.45, 0.05,
            "Resultado:", true, tab)
        local imgRes = guiCreateStaticImage(0.5, 0.6, 0.2, 0.2,
            "images/slot.png", true, tab)
            
        -- Botão craftar
        local btnCraft = guiCreateButton(0.5, 0.85, 0.45, 0.1,
            "Craftar", true, tab)
    end,
    
    atualizarInterface = function(self)
        triggerServerEvent("onRequestInventoryUpdate", localPlayer)
    end,
    
    atualizarSlot = function(self, slot, item)
        local slotGui = self.slots[slot]
        if not slotGui then return end
        
        -- Remove elementos antigos
        if slotGui.imagem then
            destroyElement(slotGui.imagem)
            slotGui.imagem = nil
        end
        
        if slotGui.quantidade then
            destroyElement(slotGui.quantidade)
            slotGui.quantidade = nil
        end
        
        -- Sem item
        if not item then return end
        
        -- Adiciona imagem
        local itemInfo = ItemSystem:getItem(item.id)
        slotGui.imagem = guiCreateStaticImage(0, 0, 1, 1,
            "images/itens/" .. itemInfo.icone, true, slotGui.background)
            
        -- Adiciona quantidade se stackável
        if itemInfo.stackavel and item.quantidade > 1 then
            slotGui.quantidade = guiCreateLabel(0.6, 0.6, 0.4, 0.4,
                tostring(item.quantidade), true, slotGui.background)
        end
    end
}

-- Bind para abrir/fechar
bindKey("i", "down",
    function()
        if InventoryGUI.window then
            InventoryGUI:hide()
        else
            InventoryGUI:show()
        end
    end
)

-- Atualização do servidor
addEvent("onInventoryUpdate", true)
addEventHandler("onInventoryUpdate", root,
    function(inventario)
        if not InventoryGUI.window then return end
        
        -- Atualiza slots
        for slot, item in pairs(inventario.slots) do
            InventoryGUI:atualizarSlot(slot, item)
        end
        
        -- Atualiza peso
        local labelPeso = guiGetText("labelPeso")
        guiSetText(labelPeso, string.format("Peso: %.1f/%.1f",
            inventario.pesoAtual, inventario.pesoMax))
    end
)
