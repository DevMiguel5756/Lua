# Elementos e Manipulação no MTA:SA

## O que são Elementos?

- Objetos básicos do MTA:SA
- Podem ser:
  - Jogadores
  - Veículos
  - Objetos
  - Markers
  - Blips
  - E muito mais!

## Tipos de Elementos

### 1. Jogadores
```lua
-- Criar/Obter
local player = getPlayerFromName("Nome")
local players = getElementsByType("player")

-- Manipular
setElementPosition(player, x, y, z)
setElementRotation(player, rx, ry, rz)
```

### 2. Veículos
```lua
-- Criar
local veiculo = createVehicle(411, x, y, z)

-- Manipular
setVehicleColor(veiculo, r, g, b)
setVehicleDamageProof(veiculo, true)
```

### 3. Objetos
```lua
-- Criar
local objeto = createObject(1337, x, y, z)

-- Manipular
setObjectScale(objeto, 2.0)
moveObject(objeto, 1000, x2, y2, z2)
```

### 4. Markers
```lua
-- Criar
local marker = createMarker(x, y, z, "cylinder")

-- Manipular
setMarkerColor(marker, r, g, b, a)
setMarkerSize(marker, size)
```

### 5. Blips
```lua
-- Criar
local blip = createBlip(x, y, z)

-- Manipular
setBlipColor(blip, r, g, b, a)
setBlipVisibleDistance(blip, distance)
```

## Manipulação Básica

### 1. Posição e Rotação
```lua
-- Posição
local x, y, z = getElementPosition(elemento)
setElementPosition(elemento, x + 1, y, z)

-- Rotação
local rx, ry, rz = getElementRotation(elemento)
setElementRotation(elemento, rx, ry, rz + 90)
```

### 2. Dimensão e Interior
```lua
-- Dimensão
setElementDimension(elemento, 1)
local dim = getElementDimension(elemento)

-- Interior
setElementInterior(elemento, 1)
local int = getElementInterior(elemento)
```

### 3. Alpha e Visibilidade
```lua
-- Alpha
setElementAlpha(elemento, 128)  -- 50% transparente

-- Visibilidade
setElementVisibleTo(elemento, player, true)
```

## Manipulação Avançada

### 1. Dados Customizados
```lua
-- Setar dados
setElementData(elemento, "vida", 100)
setElementData(elemento, "energia", 100)

-- Obter dados
local vida = getElementData(elemento, "vida")
local energia = getElementData(elemento, "energia")

-- Handler de mudança
addEventHandler("onElementDataChange", root,
    function(dataName, oldValue)
        if dataName == "vida" then
            local newValue = getElementData(source, dataName)
            outputChatBox("Vida mudou: " .. oldValue .. " -> " .. newValue)
        end
    end
)
```

### 2. Attachments
```lua
-- Anexar elementos
attachElements(elemento1, elemento2)

-- Anexar com offset
attachElements(elemento1, elemento2, 
    offsetX, offsetY, offsetZ,
    rotX, rotY, rotZ)

-- Desanexar
detachElements(elemento1, elemento2)
```

### 3. Colisões
```lua
-- Ativar/Desativar
setElementCollisionsEnabled(elemento, false)

-- Verificar colisão
local hit, x, y, z = processLineOfSight(
    startX, startY, startZ,
    endX, endY, endZ
)
```

## Sistemas Práticos

### 1. Sistema de Elementos Dinâmicos
```lua
local ElementManager = {
    elementos = {},
    
    criar = function(self, tipo, x, y, z)
        local elemento = createElement(tipo, x, y, z)
        
        -- Registra elemento
        self.elementos[elemento] = {
            tipo = tipo,
            criado = getTickCount()
        }
        
        -- Handler de destruição
        addEventHandler("onElementDestroy", elemento,
            function()
                self.elementos[source] = nil
            end
        )
        
        return elemento
    end,
    
    destruir = function(self, elemento)
        if isElement(elemento) then
            destroyElement(elemento)
            self.elementos[elemento] = nil
        end
    end,
    
    limpar = function(self)
        for elemento in pairs(self.elementos) do
            if isElement(elemento) then
                destroyElement(elemento)
            end
        end
        self.elementos = {}
    end
}
```

### 2. Sistema de Grupos
```lua
local GrupoManager = {
    grupos = {},
    
    criarGrupo = function(self, nome)
        if not self.grupos[nome] then
            self.grupos[nome] = {
                elementos = {},
                count = 0
            }
        end
        return self.grupos[nome]
    end,
    
    adicionarElemento = function(self, grupo, elemento)
        if not self.grupos[grupo] then
            self:criarGrupo(grupo)
        end
        
        self.grupos[grupo].elementos[elemento] = true
        self.grupos[grupo].count = self.grupos[grupo].count + 1
        
        setElementData(elemento, "grupo", grupo)
    end,
    
    removerElemento = function(self, grupo, elemento)
        if self.grupos[grupo] then
            self.grupos[grupo].elementos[elemento] = nil
            self.grupos[grupo].count = self.grupos[grupo].count - 1
            
            setElementData(elemento, "grupo", nil)
        end
    end,
    
    getElementosGrupo = function(self, grupo)
        if self.grupos[grupo] then
            return self.grupos[grupo].elementos
        end
        return {}
    end
}
```

### 3. Sistema de Áreas
```lua
local AreaManager = {
    areas = {},
    
    criarArea = function(self, nome, x, y, z, raio)
        local area = {
            nome = nome,
            posicao = {x = x, y = y, z = z},
            raio = raio,
            elementos = {},
            colshape = createColSphere(x, y, z, raio)
        }
        
        -- Handlers
        addEventHandler("onColShapeHit", area.colshape,
            function(elemento)
                self:elementoEntrou(area, elemento)
            end
        )
        
        addEventHandler("onColShapeLeave", area.colshape,
            function(elemento)
                self:elementoSaiu(area, elemento)
            end
        )
        
        self.areas[nome] = area
        return area
    end,
    
    elementoEntrou = function(self, area, elemento)
        area.elementos[elemento] = true
        
        -- Notifica
        triggerEvent("onElementEnterArea", elemento, area.nome)
    end,
    
    elementoSaiu = function(self, area, elemento)
        area.elementos[elemento] = nil
        
        -- Notifica
        triggerEvent("onElementLeaveArea", elemento, area.nome)
    end
}
```

## Dicas e Boas Práticas

### 1. Performance
```lua
-- Cache de funções
local getElementPosition = getElementPosition
local setElementPosition = setElementPosition

-- Evite loops desnecessários
local function atualizarElementos()
    for elemento in pairs(elementos) do
        -- Atualiza
    end
end
setTimer(atualizarElementos, 1000, 0)
```

### 2. Segurança
```lua
-- Sempre verifique elementos
function isValidElement(elemento)
    return isElement(elemento) and getElementType(elemento) == "player"
end

-- Verifique permissões
function canModifyElement(player, elemento)
    local account = getPlayerAccount(player)
    return hasObjectPermissionTo(account, "element.modify")
end
```

### 3. Debug
```lua
function debugElemento(elemento)
    local tipo = getElementType(elemento)
    local pos = {getElementPosition(elemento)}
    
    outputDebugString(string.format("Elemento: %s, Pos: %.2f,%.2f,%.2f",
        tipo,
        unpack(pos)
    ))
end
```

## Exercícios

1. Crie um sistema que:
   - Rastreia todos os elementos criados
   - Permite agrupar elementos
   - Implementa funções de busca

2. Implemente um sistema de áreas que:
   - Define áreas no mapa
   - Detecta elementos dentro da área
   - Aplica efeitos aos elementos

3. Desenvolva um sistema de attachments que:
   - Permite anexar elementos com offset
   - Mantém hierarquia de elementos
   - Atualiza posições em tempo real

## Conclusão

- Elementos são fundamentais no MTA:SA
- Manipulação correta é essencial
- Use sistemas organizados
- Mantenha boas práticas
- Documente seu código
