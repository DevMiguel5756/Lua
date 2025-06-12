# Exercícios Intermediários - Complemento

E aí galera! 😎 Aqui tem mais uns exercícios maneiros pra você treinar! São tipo uma continuação dos outros exercícios intermediários.

## 1. Sistema de Conquistas

### Exercício 1.1 - Conquistas Maneiras
Crie um sistema que:
- Tem várias conquistas diferentes
- Dá recompensas quando completar
- Mostra progresso de cada uma
- Tem um painel pra ver tudo

```lua
local conquistas = {
    ["Matador"] = {
        descricao = "Mate 100 players",
        progresso = 0,
        meta = 100,
        recompensa = 10000
    },
    ["Piloto"] = {
        descricao = "Dirija por 1 hora",
        progresso = 0,
        meta = 3600000, -- 1 hora em ms
        recompensa = 5000
    }
}

function verificarConquista(player, tipo)
    -- Seu código aqui
end

function darRecompensa(player, conquista)
    -- Seu código aqui
end

function mostrarProgresso(player)
    -- Seu código aqui
end
```

## 2. Sistema de Missões

### Exercício 2.1 - Missões Daoras
Crie um sistema que:
- Tem missões aleatórias
- Cada uma tem objetivos diferentes
- Dá recompensas maneiras
- Tem uma história legal

```lua
local missoes = {
    ["Entrega"] = {
        tipo = "delivery",
        tempo = 300000, -- 5 minutos
        recompensa = {
            dinheiro = 5000,
            xp = 100
        }
    },
    ["Caçada"] = {
        tipo = "hunt",
        alvos = 5,
        recompensa = {
            dinheiro = 10000,
            xp = 200
        }
    }
}

function iniciarMissao(player, tipo)
    -- Seu código aqui
end

function verificarObjetivo(player)
    -- Seu código aqui
end

function finalizarMissao(player)
    -- Seu código aqui
end
```

## 3. Sistema de Customização

### Exercício 3.1 - Customização Insana
Crie um sistema que:
- Dá pra customizar o personagem
- Tem várias roupas diferentes
- Salva os visuais criados
- Tem preview em tempo real

```lua
local customizacao = {
    roupas = {
        cabeca = {},
        corpo = {},
        pernas = {},
        pes = {}
    },
    cores = {
        cabelo = {},
        pele = {},
        roupa = {}
    }
}

function aplicarVisual(player, visual)
    -- Seu código aqui
end

function salvarVisual(player, nome)
    -- Seu código aqui
end

function carregarVisual(player, nome)
    -- Seu código aqui
end
```

## 4. Sistema de Ranking

### Exercício 4.1 - Ranking Maneiro
Crie um sistema que:
- Tem vários tipos de ranking
- Atualiza em tempo real
- Mostra os melhores players
- Dá prêmios pros tops

```lua
local rankings = {
    kills = {},
    dinheiro = {},
    nivel = {},
    tempo = {}
}

function atualizarRanking(tipo, player, valor)
    -- Seu código aqui
end

function mostrarTop10(player, tipo)
    -- Seu código aqui
end

function darPremioTop(tipo)
    -- Seu código aqui
end
```

## 5. Sistema de Eventos

### Exercício 5.1 - Eventos Automáticos
Crie um sistema que:
- Cria eventos aleatórios
- Tem vários tipos diferentes
- Dá prêmios pros vencedores
- Avisa todo mundo quando rolar

```lua
local eventos = {
    ["Battle Royale"] = {
        min_players = 4,
        tempo = 600000, -- 10 minutos
        area = {x = 0, y = 0, z = 0, raio = 100}
    },
    ["Corrida"] = {
        min_players = 2,
        checkpoints = 5,
        tempo = 300000 -- 5 minutos
    }
}

function iniciarEvento(tipo)
    -- Seu código aqui
end

function gerenciarEvento(tipo)
    -- Seu código aqui
end

function finalizarEvento(tipo)
    -- Seu código aqui
end
```

## Dicas Extra

### Como Melhorar os Sistemas
1. Adiciona sons maneiros
2. Coloca efeitos visuais
3. Faz uma interface bonita
4. Deixa tudo conectado

### Como Testar
1. Testa com vários players
2. Vê se não tem bugs
3. Checa a performance
4. Pega feedback da galera

### Como Organizar
1. Separa em arquivos
2. Usa funções úteis
3. Comenta tudo
4. Faz backup sempre

## Desafios Extra

### Ideias Maneiras
1. Sistema de achievements global
2. Ranking entre clans
3. Eventos especiais em datas comemorativas
4. Sistema de reputação
5. Economia entre servers

Lembra:
- Testa tudo muito bem
- Faz backup sempre
- Documenta as mudanças
- Se divirte criando! 🎮
