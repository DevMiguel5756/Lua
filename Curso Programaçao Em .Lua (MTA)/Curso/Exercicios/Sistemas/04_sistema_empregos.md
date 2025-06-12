# Sistema de Empregos MTA:SA

E aí mano! Vamo criar um sistema de empregos maneiro? Aqui vai o passo a passo:

## 1. Estrutura Básica

### 1.1 Banco de Dados
Primeiro, vamo criar as tabelas:
```sql
CREATE TABLE empregos (
    id INT PRIMARY KEY,
    nome VARCHAR(50),
    salario FLOAT,
    nivel_min INT,
    requisitos TEXT
);

CREATE TABLE empregados (
    id INT PRIMARY KEY,
    player VARCHAR(50),
    emprego_id INT,
    nivel INT,
    exp FLOAT,
    horas_trabalhadas FLOAT
);
```

### 1.2 Funções Base
Funções principais q vamos precisar:
```lua
-- Funções do emprego
function conseguirEmprego(player, emprego)
    -- Seu código aqui
end

function iniciarTrabalho(player)
    -- Seu código aqui
end

function finalizarTrabalho(player)
    -- Seu código aqui
end

function receberPagamento(player)
    -- Seu código aqui
end
```

## 2. Sistema de Trabalho

### 2.1 Missões
Sistema de missões q:
- Gera tarefas aleatórias
- Define objetivos
- Calcula recompensas
- Dá experiência

```lua
-- Sistema de missões
function criarMissao(emprego)
    local missao = {
        tipo = getMissaoAleatoria(emprego),
        objetivo = getObjetivo(),
        recompensa = calcularRecompensa(),
        exp = calcularExp()
    }
    
    return missao
end
```

### 2.2 Progressão
Add sistema q:
- Aumenta nível
- Dá bônus
- Libera skills
- Tem rankings

```lua
-- Sistema de progressão
function addExperiencia(player, valor)
    local exp = getPlayerExp(player)
    local nivel = calcularNivel(exp + valor)
    
    if nivel > getPlayerNivel(player) then
        subirNivel(player, nivel)
    end
end
```

## 3. Tipos de Emprego

### 3.1 Motorista
Sistema de entregas:
- Rotas dinâmicas
- Tempo limite
- Bônus por velocidade
- Penalidade por dano

```lua
-- Sistema de entregas
function criarEntrega(player)
    local rota = {
        inicio = getPontoInicial(),
        fim = getPontoFinal(),
        tempo = calcularTempo(),
        carga = getCargaAleatoria()
    }
    
    return rota
end
```

### 3.2 Polícia
Sistema policial:
- Perseguições
- Multas
- Prisões
- Investigações

```lua
-- Sistema policial
function iniciarPerseguicao(policial, suspeito)
    if not isPolicial(policial) then return false end
    -- Iniciar perseguição
end
```

### 3.3 Médico
Sistema médico:
- Atendimentos
- Cirurgias
- Ambulância
- Hospital

```lua
-- Sistema médico
function atenderPaciente(medico, paciente)
    if not isMedico(medico) then return false end
    -- Realizar atendimento
end
```

## 4. Interface

### 4.1 Menu de Empregos
Interface q mostra:
- Lista de empregos
- Requisitos
- Salários
- Benefícios

```lua
-- Menu de empregos
function abrirMenuEmpregos()
    local window = guiCreateWindow(0.3, 0.3, 0.4, 0.4, "Empregos", true)
    
    -- Lista de empregos
    local gridEmpregos = guiCreateGridList(0.05, 0.1, 0.9, 0.7, true, window)
    
    -- Botões
    local btnAplicar = guiCreateButton(0.3, 0.85, 0.4, 0.1, "Aplicar", true, window)
end
```

### 4.2 HUD do Trabalho
Mostra na tela:
- Missão atual
- Tempo restante
- Progresso
- Recompensa

```lua
-- HUD do trabalho
function atualizarHUD(player)
    local missao = getPlayerMissao(player)
    local tempo = getMissaoTempo(missao)
    
    -- Atualizar interface
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
2. Teste missões
3. Verifique sync
4. Corrija bugs

### 5.3 Organização
1. Comente bem
2. Separe em módulos
3. Use eventos
4. Documente tudo

## 6. Extras

### 6.1 Features Legais
- Uniforme
- Ferramentas
- Veículos especiais
- Skills únicas

### 6.2 Social
- Equipes
- Rankings
- Achievements
- Eventos

## 7. Próximos Passos

Depois q terminar:
1. Teste tudo
2. Otimize
3. Add features
4. Atualize sempre

Lembra:
- Teste bastante
- Balance os empregos
- Mantenha divertido
- Divirta-se!

# Exercício: Sistema de Empregos

## Objetivo
Criar um sistema completo de empregos com:
- Diferentes profissões
- Progressão de carreira
- Salários e bônus
- Missões específicas
- Sistema de habilidades

## Requisitos

### 1. Sistema Base de Empregos
```lua
local JobSystem = {
    empregos = {
        ["policial"] = {
            nome = "Policial",
            salarioBase = 1000,
            niveis = {
                [1] = {nome = "Recruta", bonus = 0},
                [2] = {nome = "Oficial", bonus = 200},
                [3] = {nome = "Sargento", bonus = 500},
                [4] = {nome = "Tenente", bonus = 1000},
                [5] = {nome = "Capitão", bonus = 2000}
            },
            habilidades = {
                "tiro",
                "direção",
                "investigação"
            },
            uniforme = {
                [1] = {280, 281, 282, 283, 284},
                [2] = {285, 286, 287},
                [3] = {288, 289, 290},
                [4] = {291, 292, 293},
                [5] = {294, 295, 296}
            },
            veiculos = {
                [1] = {596, 597},
                [2] = {598, 599},
                [3] = {601},
                [4] = {427},
                [5] = {497, 528}
            }
        },
        ["medico"] = {
            nome = "Médico",
            salarioBase = 1200,
            niveis = {
                [1] = {nome = "Estagiário", bonus = 0},
                [2] = {nome = "Residente", bonus = 300},
                [3] = {nome = "Médico", bonus = 600},
                [4] = {nome = "Especialista", bonus = 1200},
                [5] = {nome = "Chefe", bonus = 2500}
            },
            habilidades = {
                "primeiros_socorros",
                "cirurgia",
                "diagnóstico"
            },
            uniforme = {
                [1] = {274, 275},
                [2] = {276, 277},
                [3] = {278, 279},
                [4] = {280, 281},
                [5] = {282, 283}
            },
            veiculos = {
                [1] = {416},
                [2] = {416},
                [3] = {416},
                [4] = {416},
                [5] = {563}
            }
        },
        -- Adicione mais empregos
    },
    
    jogadores = {},
    
    contratarJogador = function(self, player, emprego)
        if self.jogadores[player] then
            outputChatBox("Você já tem um emprego!", player, 255, 0, 0)
            return false
        end
        
        local infoEmprego = self.empregos[emprego]
        if not infoEmprego then return false end
        
        self.jogadores[player] = {
            emprego = emprego,
            nivel = 1,
            experiencia = 0,
            habilidades = {},
            ultimoSalario = 0,
            horasTrabalhadas = 0
        }
        
        -- Inicializa habilidades
        for _, hab in ipairs(infoEmprego.habilidades) do
            self.jogadores[player].habilidades[hab] = 0
        end
        
        -- Aplica uniforme inicial
        local skin = infoEmprego.uniforme[1][1]
        setElementModel(player, skin)
        
        outputChatBox("Você foi contratado como " .. infoEmprego.nome .. "!",
            player, 0, 255, 0)
            
        return true
    end,
    
    demitirJogador = function(self, player)
        if not self.jogadores[player] then
            outputChatBox("Você não tem um emprego!", player, 255, 0, 0)
            return false
        end
        
        -- Remove emprego
        self.jogadores[player] = nil
        
        -- Reseta skin
        setElementModel(player, 0)
        
        outputChatBox("Você foi demitido!", player, 255, 0, 0)
        return true
    end,
    
    addExperiencia = function(self, player, quantidade)
        local dados = self.jogadores[player]
        if not dados then return false end
        
        dados.experiencia = dados.experiencia + quantidade
        
        -- Verifica level up
        local expNecessaria = self:getExpNecessaria(dados.nivel)
        if dados.experiencia >= expNecessaria then
            self:levelUp(player)
        end
        
        return true
    end,
    
    levelUp = function(self, player)
        local dados = self.jogadores[player]
        if not dados then return false end
        
        local infoEmprego = self.empregos[dados.emprego]
        if not infoEmprego.niveis[dados.nivel + 1] then
            return false
        end
        
        -- Aumenta nível
        dados.nivel = dados.nivel + 1
        dados.experiencia = 0
        
        -- Notifica
        local novoNivel = infoEmprego.niveis[dados.nivel]
        outputChatBox("Parabéns! Você foi promovido para " .. novoNivel.nome .. "!",
            player, 0, 255, 0)
            
        -- Atualiza uniforme
        local skin = infoEmprego.uniforme[dados.nivel][1]
        setElementModel(player, skin)
        
        return true
    end,
    
    getExpNecessaria = function(self, nivel)
        return nivel * 1000
    end,
    
    pagarSalario = function(self)
        for player, dados in pairs(self.jogadores) do
            if isElement(player) then
                local infoEmprego = self.empregos[dados.emprego]
                local infoNivel = infoEmprego.niveis[dados.nivel]
                
                local salario = infoEmprego.salarioBase + infoNivel.bonus
                
                -- Adiciona bônus por habilidades
                for hab, nivel in pairs(dados.habilidades) do
                    salario = salario + (nivel * 100)
                end
                
                -- Paga jogador
                givePlayerMoney(player, salario)
                dados.ultimoSalario = salario
                
                outputChatBox("Salário recebido: $" .. salario, player, 0, 255, 0)
            end
        end
    end,
    
    melhorarHabilidade = function(self, player, habilidade)
        local dados = self.jogadores[player]
        if not dados then return false end
        
        local infoEmprego = self.empregos[dados.emprego]
        if not table.find(infoEmprego.habilidades, habilidade) then
            return false
        end
        
        if dados.habilidades[habilidade] >= 100 then
            return false
        end
        
        dados.habilidades[habilidade] = dados.habilidades[habilidade] + 1
        return true
    end,
    
    getInfoJogador = function(self, player)
        return self.jogadores[player]
    end
}

-- Timer para pagar salários
setTimer(function()
    JobSystem:pagarSalario()
end, 60 * 60 * 1000, 0)  -- A cada hora
```

### 2. Sistema de Missões
```lua
local MissionSystem = {
    missoes = {
        ["policial"] = {
            {
                nome = "Patrulha",
                nivel = 1,
                descricao = "Faça uma ronda pela cidade",
                tipo = "patrulha",
                objetivo = 5,  -- 5 checkpoints
                recompensa = {
                    dinheiro = 200,
                    exp = 100
                }
            },
            {
                nome = "Perseguição",
                nivel = 2,
                descricao = "Persiga e prenda o suspeito",
                tipo = "perseguicao",
                objetivo = 1,  -- 1 prisão
                recompensa = {
                    dinheiro = 500,
                    exp = 250
                }
            },
            -- Adicione mais missões
        },
        ["medico"] = {
            {
                nome = "Atendimento",
                nivel = 1,
                descricao = "Atenda pacientes no hospital",
                tipo = "atendimento",
                objetivo = 3,  -- 3 pacientes
                recompensa = {
                    dinheiro = 300,
                    exp = 150
                }
            },
            {
                nome = "Emergência",
                nivel = 2,
                descricao = "Responda a chamados de emergência",
                tipo = "emergencia",
                objetivo = 2,  -- 2 resgates
                recompensa = {
                    dinheiro = 600,
                    exp = 300
                }
            },
            -- Adicione mais missões
        }
    },
    
    missoesAtivas = {},
    
    iniciarMissao = function(self, player, nome)
        local dados = JobSystem:getInfoJogador(player)
        if not dados then return false end
        
        local missoes = self.missoes[dados.emprego]
        if not missoes then return false end
        
        local missao
        for _, m in ipairs(missoes) do
            if m.nome == nome and dados.nivel >= m.nivel then
                missao = m
                break
            end
        end
        
        if not missao then
            outputChatBox("Missão não encontrada ou nível insuficiente!",
                player, 255, 0, 0)
            return false
        end
        
        if self.missoesAtivas[player] then
            outputChatBox("Você já está em uma missão!", player, 255, 0, 0)
            return false
        end
        
        -- Inicia missão
        self.missoesAtivas[player] = {
            nome = nome,
            progresso = 0,
            inicio = getTickCount()
        }
        
        -- Cria objetivos baseado no tipo
        if missao.tipo == "patrulha" then
            self:criarCheckpointsPatrulha(player, missao.objetivo)
        elseif missao.tipo == "perseguicao" then
            self:criarPerseguicao(player)
        elseif missao.tipo == "atendimento" then
            self:criarPacientes(player, missao.objetivo)
        elseif missao.tipo == "emergencia" then
            self:criarEmergencias(player, missao.objetivo)
        end
        
        outputChatBox("Missão iniciada: " .. missao.descricao, player, 0, 255, 0)
        return true
    end,
    
    atualizarProgresso = function(self, player, quantidade)
        local missaoAtiva = self.missoesAtivas[player]
        if not missaoAtiva then return false end
        
        local dados = JobSystem:getInfoJogador(player)
        local missao = self.missoes[dados.emprego][missaoAtiva.nome]
        
        missaoAtiva.progresso = missaoAtiva.progresso + quantidade
        
        -- Verifica conclusão
        if missaoAtiva.progresso >= missao.objetivo then
            self:concluirMissao(player)
        else
            outputChatBox("Progresso: " .. missaoAtiva.progresso .. "/" ..
                missao.objetivo, player, 255, 255, 0)
        end
        
        return true
    end,
    
    concluirMissao = function(self, player)
        local missaoAtiva = self.missoesAtivas[player]
        if not missaoAtiva then return false end
        
        local dados = JobSystem:getInfoJogador(player)
        local missao = self.missoes[dados.emprego][missaoAtiva.nome]
        
        -- Dá recompensas
        givePlayerMoney(player, missao.recompensa.dinheiro)
        JobSystem:addExperiencia(player, missao.recompensa.exp)
        
        -- Notifica
        outputChatBox("Missão concluída! +" .. missao.recompensa.dinheiro ..
            "$ +" .. missao.recompensa.exp .. "XP", player, 0, 255, 0)
            
        -- Remove missão
        self.missoesAtivas[player] = nil
        
        return true
    end,
    
    falharMissao = function(self, player)
        local missaoAtiva = self.missoesAtivas[player]
        if not missaoAtiva then return false end
        
        outputChatBox("Missão falhou!", player, 255, 0, 0)
        
        -- Remove missão
        self.missoesAtivas[player] = nil
        
        return true
    end
}
```

### 3. Interface Gráfica
```lua
-- Cliente
local JobGUI = {
    window = nil,
    
    show = function(self)
        if self.window then return end
        
        -- Cria janela
        self.window = guiCreateWindow(0.3, 0.3, 0.4, 0.4,
            "Painel de Emprego", true)
            
        -- Tabs
        local tabPanel = guiCreateTabPanel(0.02, 0.08, 0.96, 0.9, true,
            self.window)
            
        -- Tab Info
        local tabInfo = guiCreateTab("Informações", tabPanel)
        self:criarTabInfo(tabInfo)
        
        -- Tab Missões
        local tabMissoes = guiCreateTab("Missões", tabPanel)
        self:criarTabMissoes(tabMissoes)
        
        -- Tab Habilidades
        local tabHabilidades = guiCreateTab("Habilidades", tabPanel)
        self:criarTabHabilidades(tabHabilidades)
        
        -- Mostra cursor
        showCursor(true)
        
        -- Atualiza informações
        self:atualizarInfo()
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
            "Emprego: ",
            "Nível: ",
            "Experiência: ",
            "Próximo nível: ",
            "Último salário: ",
            "Horas trabalhadas: "
        }
        
        for _, texto in ipairs(labels) do
            guiCreateLabel(0.1, y, 0.3, 0.1, texto, true, tab)
            y = y + 0.15
        end
        
        -- Botões
        local btnPedir = guiCreateButton(0.1, 0.8, 0.2, 0.1,
            "Pedir Emprego", true, tab)
        local btnDemitir = guiCreateButton(0.35, 0.8, 0.2, 0.1,
            "Pedir Demissão", true, tab)
    end,
    
    criarTabMissoes = function(self, tab)
        -- Lista de missões
        local gridlist = guiCreateGridList(0.05, 0.05, 0.9, 0.7, true, tab)
        
        guiGridListAddColumn(gridlist, "Nome", 0.3)
        guiGridListAddColumn(gridlist, "Nível", 0.2)
        guiGridListAddColumn(gridlist, "Recompensa", 0.2)
        guiGridListAddColumn(gridlist, "Experiência", 0.2)
        
        -- Botões
        local btnIniciar = guiCreateButton(0.3, 0.8, 0.4, 0.15,
            "Iniciar Missão", true, tab)
    end,
    
    criarTabHabilidades = function(self, tab)
        -- Lista de habilidades
        local gridlist = guiCreateGridList(0.05, 0.05, 0.9, 0.7, true, tab)
        
        guiGridListAddColumn(gridlist, "Habilidade", 0.4)
        guiGridListAddColumn(gridlist, "Nível", 0.3)
        guiGridListAddColumn(gridlist, "Progresso", 0.3)
        
        -- Botão de treino
        local btnTreinar = guiCreateButton(0.3, 0.8, 0.4, 0.15,
            "Treinar Habilidade", true, tab)
    end,
    
    atualizarInfo = function(self)
        triggerServerEvent("onRequestJobInfo", localPlayer)
    end
}

-- Bind para abrir/fechar
bindKey("F7", "down",
    function()
        if JobGUI.window then
            JobGUI:hide()
        else
            JobGUI:show()
        end
    end
)

-- Render de missão
addEventHandler("onClientRender", root,
    function()
        if not isElement(localPlayer) then return end
        
        local missao = MissionSystem.missoesAtivas[localPlayer]
        if not missao then return end
        
        -- Render de objetivo
        local x, y, z = getElementPosition(localPlayer)
        local objetivo = missao.objetivos[missao.progresso + 1]
        
        if objetivo then
            dxDrawLine3D(x, y, z, objetivo.x, objetivo.y, objetivo.z,
                tocolor(255, 255, 0, 200), 2)
                
            local dist = getDistanceBetweenPoints3D(x, y, z,
                objetivo.x, objetivo.y, objetivo.z)
                
            dxDrawText("Distância: " .. math.floor(dist) .. "m",
                10, 10, nil, nil, tocolor(255, 255, 255, 255),
                1.5, "default-bold")
        end
        
        -- Render de progresso
        dxDrawText("Progresso: " .. missao.progresso .. "/" ..
            #missao.objetivos,
            10, 40, nil, nil, tocolor(255, 255, 255, 255),
            1.5, "default-bold")
    end
)
```

## Desafios Extras

1. Adicione mais empregos:
   - Bombeiro
   - Mecânico
   - Taxista
   - Piloto
   - Pescador

2. Implemente um sistema de carreira:
   - Histórico de empregos
   - Reputação
   - Referências
   - Currículo

3. Crie um sistema de treinamento:
   - Academias
   - Cursos
   - Certificações
   - Especialização

4. Adicione eventos especiais:
   - Promoções em massa
   - Competições
   - Prêmios
   - Bônus

## Dicas

1. Use markers para pontos de trabalho

2. Implemente um sistema de turnos

3. Adicione uniformes e equipamentos

4. Crie missões dinâmicas

## Avaliação

Seu sistema será avaliado nos seguintes aspectos:

1. Funcionalidade
   - Sistema de progressão
   - Missões variadas
   - Salários justos

2. Interface
   - GUI intuitiva
   - HUD informativo
   - Feedback claro

3. Código
   - Bem organizado
   - Otimizado
   - Expansível

4. Extras
   - Variedade de empregos
   - Sistema de carreira
   - Eventos especiais
