--[[ 
    Sistema de Login Básico
    
    Mano, esse sistema é suave! Ele faz:
    - Login dos players
    - Salva os dados
    - Carrega quando volta
    
    Só não esquece de botar na sua meta.xml:
    <script src="01_sistema_login.lua" type="server"/>
]]

-- Variáveis do role
local jogadores = {} -- Guarda os dados da galera

-- Função pra registrar novo jogador, tá ligado?
function registrarJogador(player, cmd, senha)
    if not senha then
        return outputChatBox("Uso: /registrar [senha]", player, 255, 0, 0)
    end
    
    local account = getPlayerAccount(player)
    if account then
        return outputChatBox("Você já está registrado!", player, 255, 0, 0)
    end
    
    local username = getPlayerName(player)
    if addAccount(username, senha) then
        outputChatBox("Conta criada com sucesso!", player, 0, 255, 0)
    else
        outputChatBox("Erro ao criar conta!", player, 255, 0, 0)
    end
end
addCommandHandler("registrar", registrarJogador)

-- Função pra fazer login, mo importante isso aqui
function loginJogador(player, cmd, senha)
    if not senha then
        return outputChatBox("Uso: /login [senha]", player, 255, 0, 0)
    end
    
    local account = getPlayerAccount(player)
    if account then
        return outputChatBox("Você já está logado!", player, 255, 0, 0)
    end
    
    local username = getPlayerName(player)
    account = getAccount(username, senha)
    
    if account and logIn(player, account, senha) then
        outputChatBox("Login realizado com sucesso!", player, 0, 255, 0)
        carregarDadosJogador(player)
    else
        outputChatBox("Senha incorreta!", player, 255, 0, 0)
    end
end
addCommandHandler("login", loginJogador)

-- Função pra carregar dados do jogador, mo útil
function carregarDadosJogador(player)
    local account = getPlayerAccount(player)
    if account then
        -- Carrega dados salvos ou define valores padrão
        local dinheiro = getAccountData(account, "dinheiro") or 1000
        local nivel = getAccountData(account, "nivel") or 1
        local experiencia = getAccountData(account, "experiencia") or 0
        
        -- Aplica os dados ao jogador
        setPlayerMoney(player, dinheiro)
        setElementData(player, "nivel", nivel)
        setElementData(player, "experiencia", experiencia)
        
        -- Salva referência na tabela de jogadores
        jogadores[player] = {
            dinheiro = dinheiro,
            nivel = nivel,
            experiencia = experiencia,
            ultimoSave = getTickCount()
        }
    end
end

-- Função pra salvar dados do jogador, mo importante isso aqui
function salvarDadosJogador(player)
    local account = getPlayerAccount(player)
    if account and not isGuestAccount(account) then
        local dados = jogadores[player]
        if dados then
            setAccountData(account, "dinheiro", getPlayerMoney(player))
            setAccountData(account, "nivel", dados.nivel)
            setAccountData(account, "experiencia", dados.experiencia)
            dados.ultimoSave = getTickCount()
            outputChatBox("Seus dados foram salvos!", player, 0, 255, 0)
        end
    end
end

-- Auto-save a cada 5 minutos, tá ligado?
setTimer(function()
    for player, dados in pairs(jogadores) do
        if isElement(player) and dados.ultimoSave + 300000 < getTickCount() then
            salvarDadosJogador(player)
        end
    end
end, 300000, 0)

-- Salvar dados quando o jogador sair, mo importante isso aqui
addEventHandler("onPlayerQuit", root, function()
    if jogadores[source] then
        salvarDadosJogador(source)
        jogadores[source] = nil
    end
end)

-- Comando pra ver status, mo útil
function verStatus(player)
    if jogadores[player] then
        local dados = jogadores[player]
        outputChatBox("=== Seu Status ===", player, 255, 255, 0)
        outputChatBox("Dinheiro: $" .. getPlayerMoney(player), player, 255, 255, 0)
        outputChatBox("Nível: " .. dados.nivel, player, 255, 255, 0)
        outputChatBox("Experiência: " .. dados.experiencia, player, 255, 255, 0)
    end
end
addCommandHandler("status", verStatus)
