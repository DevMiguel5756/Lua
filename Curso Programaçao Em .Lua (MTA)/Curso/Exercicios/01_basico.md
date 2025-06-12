# Exercícios Interativos - Nível Básico

E aí galera! Bora codar um pouco? 😎 Preparei uns exercícios maneiros pra você treinar:

## Exercício 1: Hello World Personalizado
**Objetivo:** Criar um comando que dá um salve pro player com o nome dele.

### Tarefa:
1. Crie um comando `/oi` que:
   - Pega o nome do player
   - Manda uma mensagem maneira
   - Toca um som daora

### Template:
```lua
function cumprimentar(player)
    -- Seu código aqui
end
addCommandHandler("oi", cumprimentar)
```

### Dicas:
- Usa `getPlayerName(player)` pra pegar o nome
- Usa `outputChatBox()` pra mandar a mensagem
- Usa `playSound()` pra tocar um som legal

## Exercício 2: Calculadora Básica
**Objetivo:** Criar uma calculadora que soma dois números.

### Tarefa:
1. Crie um comando `/somar [num1] [num2]` que:
   - Checa se os números tão certinhos
   - Faz a soma
   - Mostra o resultado

### Template:
```lua
function somar(player, cmd, num1, num2)
    -- Seu código aqui
end
addCommandHandler("somar", somar)
```

### Dicas:
- Usa `tonumber()` pra transformar texto em número
- Checa se os números foram digitados
- Coloca umas mensagens de erro amigáveis

## Exercício 3: Sistema de Spawn de Carros
**Objetivo:** Criar um sistema pra spawnar uns carros maneiros.

### Tarefa:
1. Crie um comando `/carro [modelo]` que:
   - Checa se o modelo existe
   - Cria o carro pertinho do player
   - Coloca o player dentro do carro

### Template:
```lua
function spawnCarro(player, cmd, modelo)
    -- Seu código aqui
end
addCommandHandler("carro", spawnCarro)
```

### Dicas:
- Usa `createVehicle()` pra criar o carro
- Usa `getElementPosition()` pra saber onde o player tá
- Usa `warpPedIntoVehicle()` pra colocar ele no carro

## Exercício 4: Sistema de Teleporte
**Objetivo:** Criar um sistema maneiro de teleporte com markers.

### Tarefa:
1. Cria uns markers em lugares legais
2. Quando o player entrar no marker:
   - Teleporta ele pra outro lugar
   - Manda uma mensagem daora
   - Coloca um efeito visual maneiro

### Template:
```lua
local teleportes = {
    {x = 0, y = 0, z = 3, destino = {x = 100, y = 100, z = 3}},
    -- Coloca mais lugares aqui
}

function criarTeleportes()
    -- Seu código aqui
end

function onMarkerHit(player)
    -- Seu código aqui
end
```

### Dicas:
- Usa `createMarker()` pra criar os markers
- Usa `setElementPosition()` pra teleportar
- Usa `createBlip()` pra marcar no mapa

## Exercício 5: Sistema de Pontuação
**Objetivo:** Criar um sistema daora de pontuação.

### Tarefa:
1. Crie um sistema que:
   - Guarda os pontos dos players
   - Mostra pontuação com `/pontos`
   - Mostra ranking com `/top`

### Template:
```lua
local pontuacao = {}

function adicionarPontos(player, quantidade)
    -- Seu código aqui
end

function verPontos(player)
    -- Seu código aqui
end

function verRanking(player)
    -- Seu código aqui
end
```

### Dicas:
- Usa uma tabela pra guardar os pontos
- Ordena o ranking com `table.sort()`
- Salva os dados quando o player sair

## Como Testar seus Códigos

1. Cria um resource novo pra cada exercício
2. Cola o template que eu dei
3. Faz sua mágica no código
4. Testa tudo pra ver se tá funcionando
5. Checa se tem algum erro

## Desafios Extras

Tenta adicionar essas coisas maneiras em cada exercício:
1. Mais checagens de erro
2. Mensagens mais legais
3. Efeitos visuais/sonoros daora
4. Funções extras
5. Interface bonita (GUI)

## Próximos Passos

Depois que terminar tudo, você vai poder:
1. Criar sistemas mais complexos
2. Mexer com banco de dados
3. Fazer interfaces maneiras
4. Criar modos de jogo completos

Lembra:
- Errar faz parte
- Pede ajuda se precisar
- Treina bastante
- Se divirte! 🎮
