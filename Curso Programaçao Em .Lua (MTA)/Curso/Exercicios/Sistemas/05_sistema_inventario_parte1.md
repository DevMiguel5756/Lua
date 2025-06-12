# Sistema de Inventário MTA:SA - Parte 1

E aí mano! Vamo criar um sistema de inventário maneiro? Aqui vai a primeira parte:

## 1. Estrutura Básica

### 1.1 Banco de Dados
Primeiro, vamo criar as tabelas:
```sql
CREATE TABLE itens (
    id INT PRIMARY KEY,
    nome VARCHAR(50),
    tipo VARCHAR(20),
    peso FLOAT,
    descricao TEXT,
    imagem VARCHAR(100)
);

CREATE TABLE inventarios (
    id INT PRIMARY KEY,
    player VARCHAR(50),
    capacidade FLOAT,
    itens TEXT
);
```

### 1.2 Funções Base
Funções principais q vamos precisar:
```lua
-- Funções do inventário
function criarInventario(player)
    -- Seu código aqui
end

function addItem(player, item)
    -- Seu código aqui
end

function removerItem(player, item)
    -- Seu código aqui
end

function usarItem(player, item)
    -- Seu código aqui
end
```

## 2. Sistema de Itens

### 2.1 Tipos de Item
Sistema q suporta:
- Armas
- Comida
- Roupas
- Ferramentas

```lua
-- Sistema de tipos
local tiposItem = {
    arma = {
        usavel = true,
        equipavel = true,
        stackavel = false
    },
    comida = {
        usavel = true,
        equipavel = false,
        stackavel = true
    }
}
```

### 2.2 Gerenciamento
Add sistema q:
- Controla peso
- Stack de itens
- Organiza slots
- Salva dados

```lua
-- Sistema de peso
function calcularPesoTotal(inventario)
    local peso = 0
    for _, item in pairs(inventario.itens) do
        peso = peso + (item.peso * item.quantidade)
    end
    return peso
end
```

## 3. Features Básicas

### 3.1 Movimentação
Sistema pra:
- Mover itens
- Dividir stacks
- Juntar itens
- Ordenar

```lua
-- Sistema de movimento
function moverItem(inv, slotOrigem, slotDestino)
    local item = inv.itens[slotOrigem]
    if not item then return false end
    -- Mover item
end
```

### 3.2 Uso de Itens
Add sistema q:
- Usa itens
- Equipa items
- Consome itens
- Combina itens

```lua
-- Sistema de uso
function usarItem(player, slot)
    local item = getInventarioItem(player, slot)
    if not item.usavel then return false end
    -- Usar item
end
```

## 4. Interface

### 4.1 Menu Principal
Interface q mostra:
- Grid de slots
- Info dos itens
- Peso atual
- Ações rápidas

```lua
-- Menu do inventário
function abrirInventario(player)
    local window = guiCreateWindow(0.3, 0.3, 0.4, 0.4, "Inventário", true)
    
    -- Grid de slots
    local gridSlots = guiCreateGridList(0.05, 0.1, 0.6, 0.8, true, window)
    
    -- Info do item
    local infoPanel = guiCreateLabel(0.7, 0.1, 0.25, 0.8, "", true, window)
end
```

### 4.2 Menu de Item
Interface q mostra:
- Nome e tipo
- Descrição
- Ações possíveis
- Preview

```lua
-- Menu do item
function mostrarInfoItem(item)
    local info = string.format([[
Nome: %s
Tipo: %s
Peso: %.1f
Descrição: %s
    ]], item.nome, item.tipo, item.peso, item.descricao)
    
    return info
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
2. Teste slots
3. Verifique peso
4. Corrija bugs

### 5.3 Organização
1. Comente bem
2. Separe em módulos
3. Use eventos
4. Documente tudo

## 6. Extras

### 6.1 Features Legais
- Raridade
- Durabilidade
- Efeitos
- Sets

### 6.2 Visual
- Ícones
- Animações
- Sons
- Efeitos

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
