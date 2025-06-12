# Exercícios Avançados MTA:SA

E aí galera! 😎 Agora vamo pro level hard: os exercícios avançados! Aqui você vai criar uns sistemas super maneiros:

## 1. Sistema de Corridas Insano
**Objetivo:** Criar um sistema completo de corridas com tudo que tem direito!

### Tarefa:
1. Fazer:
   - Editor pra criar corridas
   - Checkpoints que mudam de lugar
   - Placar ao vivo
   - Recordes que ficam salvos
   - Apostas entre os players
   - Vários tipos de corrida (Sprint, Circuito, Drift)

### Template:
```lua
local corridas = {}
local recordes = {}

-- Classe Corrida
local Corrida = {
    new = function(self, nome, tipo)
        local instance = {
            nome = nome,
            tipo = tipo,
            checkpoints = {},
            participantes = {},
            estado = "aguardando",
            tempos = {},
            apostas = {}
        }
        setmetatable(instance, {__index = self})
        return instance
    end,
    
    adicionarCheckpoint = function(self, x, y, z)
        -- Seu código aqui
    end,
    
    iniciarCorrida = function(self)
        -- Seu código aqui
    end,
    
    finalizarCorrida = function(self)
        -- Seu código aqui
    end,
    
    processarCheckpoint = function(self, player)
        -- Seu código aqui
    end
}

-- Interface do Editor
function abrirEditorCorrida(player)
    -- Seu código aqui
end

-- Sistema de Apostas
function fazerAposta(player, cmd, valor, corredor)
    -- Seu código aqui
end
```

## 2. Sistema de RPG Maneiro
**Objetivo:** Criar um RPG com várias features legais!

### Tarefa:
1. Fazer:
   - Classes diferentes com poderes únicos
   - Sistema de atributos maneiro
   - Inventário com vários itens
   - Quests que mudam sempre
   - NPCs que interagem com você
   - Dungeons pra explorar
   - Sistema pra craftar itens
   - Comércio entre players

### Template:
```lua
-- Classes
local Classes = {
    Guerreiro = {
        vida_base = 150,
        habilidades = {
            "Golpe Poderoso",
            "Defesa Total",
            "Grito de Guerra"
        }
    },
    Mago = {
        vida_base = 80,
        habilidades = {
            "Bola de Fogo",
            "Teleporte",
            "Escudo Mágico"
        }
    }
}

-- Sistema de Personagem
local Personagem = {
    new = function(self, player, classe)
        -- Seu código aqui
    end,
    
    usarHabilidade = function(self, nomeHabilidade)
        -- Seu código aqui
    end,
    
    equiparItem = function(self, item)
        -- Seu código aqui
    end,
    
    iniciarQuest = function(self, questId)
        -- Seu código aqui
    end
}

-- Sistema de Quests
local QuestManager = {
    quests = {},
    
    criarQuest = function(self, id, dados)
        -- Seu código aqui
    end,
    
    atualizarProgresso = function(self, player, questId, progresso)
        -- Seu código aqui
    end
}

-- Sistema de Crafting
local CraftingManager = {
    receitas = {},
    
    adicionarReceita = function(self, resultado, ingredientes)
        -- Seu código aqui
    end,
    
    craftarItem = function(self, player, receitaId)
        -- Seu código aqui
    end
}
```

## 3. Sistema de Guerra por Territórios
**Objetivo:** Criar um sistema massa de controle de territórios!

### Tarefa:
1. Fazer:
   - Dividir o mapa em áreas
   - Sistema pra capturar territórios
   - Vantagens por ter território
   - Alianças entre gangues
   - Economia baseada nos territórios
   - Sistema de defesas maneiro
   - Guerras marcadas

### Template:
```lua
-- Gerenciador de Territórios
local TerritorioManager = {
    territorios = {},
    
    inicializarTerritorios = function(self)
        -- Seu código aqui
    end,
    
    iniciarCaptura = function(self, territorio, faccao)
        -- Seu código aqui
    end,
    
    processarBeneficios = function(self)
        -- Seu código aqui
    end
}

-- Sistema de Facções
local FaccaoManager = {
    faccoes = {},
    
    criarFaccao = function(self, nome, lider)
        -- Seu código aqui
    end,
    
    proporAlianca = function(self, faccao1, faccao2)
        -- Seu código aqui
    end,
    
    declararGuerra = function(self, faccao1, faccao2, data)
        -- Seu código aqui
    end
}

-- Sistema de Defesas
local DefesaManager = {
    defesas = {},
    
    construirDefesa = function(self, tipo, x, y, z, faccao)
        -- Seu código aqui
    end,
    
    atualizarDefesas = function(self)
        -- Seu código aqui
    end
}
```

## 4. Sistema de Eventos Automáticos
**Objetivo:** Criar eventos que rolam sozinhos pelo mapa!

### Tarefa:
1. Fazer:
   - Eventos aleatórios pelo mapa
   - Sistema de prêmios maneiro
   - Vários tipos de eventos
   - Ranking dos participantes
   - Dificuldade que se adapta
   - Eventos especiais em grupo

### Template:
```lua
-- Gerenciador de Eventos
local EventoManager = {
    eventos = {},
    tiposEvento = {
        "Caça ao Tesouro",
        "Batalha Real",
        "Defesa do Ponto",
        "Corrida Maluca",
        "Invasão Zumbi"
    },
    
    criarEvento = function(self, tipo)
        -- Seu código aqui
    end,
    
    finalizarEvento = function(self, eventoId)
        -- Seu código aqui
    end,
    
    distribuirRecompensas = function(self, eventoId)
        -- Seu código aqui
    end
}

-- Sistema de Dificuldade
local DificuldadeManager = {
    calcularDificuldade = function(self, players)
        -- Seu código aqui
    end,
    
    ajustarParametros = function(self, evento, dificuldade)
        -- Seu código aqui
    end
}
```

## 5. Sistema de Economia Insana
**Objetivo:** Criar uma economia que funciona sozinha!

### Tarefa:
1. Fazer:
   - Mercado de ações maneiro
   - Sistema de oferta e procura
   - Inflação que muda sozinha
   - Empresas pra gerenciar
   - Impostos e taxas
   - Investimentos com retorno variável

### Template:
```lua
-- Mercado
local MercadoManager = {
    acoes = {},
    empresas = {},
    historico = {},
    
    atualizarPrecos = function(self)
        -- Seu código aqui
    end,
    
    processarTransacao = function(self, tipo, quantidade, preco)
        -- Seu código aqui
    end,
    
    calcularInflacao = function(self)
        -- Seu código aqui
    end
}

-- Sistema de Empresas
local EmpresaManager = {
    criarEmpresa = function(self, nome, dono, capitalInicial)
        -- Seu código aqui
    end,
    
    pagarDividendos = function(self, empresaId)
        -- Seu código aqui
    end,
    
    falencia = function(self, empresaId)
        -- Seu código aqui
    end
}
```

## Como Fazer os Exercícios Avançados

1. **Planejamento:**
   - Desenha como vai ser o sistema
   - Vê o que precisa de que
   - Planeja como vai salvar os dados

2. **Desenvolvimento:**
   - Começa com o básico
   - Vai adicionando as coisas aos poucos
   - Testa cada parte

3. **Otimização:**
   - Vê onde tá lento
   - Melhora o uso de memória
   - Faz rodar mais rápido

4. **Documentação:**
   - Explica as funções principais
   - Faz um guia de como usar
   - Anota as mudanças

## Dicas pra Fazer

### 4.1 Como Planejar
1. Divide em partes menores
2. Começa pelo principal
3. Adiciona as coisas aos poucos
4. Testa cada parte

### 4.2 Como Debugar
1. Usa prints pra ver o que tá rolando
2. Testa bastante
3. Pede pra galera testar
4. Arruma os bugs

### 4.3 Como Organizar
1. Comenta bastante
2. Usa nomes que fazem sentido
3. Faz funções pequenas
4. Deixa o código organizado

## Extras e Desafios

### 5.1 Coisas pra Adicionar
Tenta colocar:
- Interface bonita
- Sons e efeitos maneiros
- Animações legais
- Notificações daora

### 5.2 Desafios Extras
Tenta fazer:
- Sistema mais complexo
- Mais interação com os players
- Mais funções legais
- Código mais rápido

## O Que Fazer Depois

Quando terminar:
1. Dá uma revisada no código
2. Pede feedback da galera
3. Vê o que dá pra melhorar
4. Mostra pra todo mundo

Lembra:
- Começa devagar
- Testa bastante
- Não desiste
- Se divirte fazendo! 🎮
