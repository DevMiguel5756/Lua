# Sistema de Banco MTA:SA

E aí mano! Vamo criar um sistema de banco maneiro pro server? Aqui vai o passo a passo:

## 1. Estrutura Básica

### 1.1 Banco de Dados
Primeiro, vamo criar as tabelas:
```sql
CREATE TABLE contas_banco (
    id INT PRIMARY KEY,
    dono VARCHAR(50),
    saldo FLOAT,
    pin VARCHAR(6),
    ultima_transacao TIMESTAMP
);

CREATE TABLE transacoes (
    id INT PRIMARY KEY,
    conta_origem INT,
    conta_destino INT,
    valor FLOAT,
    tipo VARCHAR(20),
    data TIMESTAMP
);
```

### 1.2 Funções Base
Funções principais q vamos precisar:
```lua
-- Funções do banco
function criarConta(player, pin)
    -- Seu código aqui
end

function fazerDeposito(player, valor)
    -- Seu código aqui
end

function fazerSaque(player, valor)
    -- Seu código aqui
end

function verSaldo(player)
    -- Seu código aqui
end
```

## 2. Interface do Banco

### 2.1 GUI Principal
Crie uma interface q mostra:
- Saldo atual
- Botões de ação
- Histórico
- Menu de opções

```lua
-- GUI do banco
function abrirBanco(player)
    local window = guiCreateWindow(0.3, 0.3, 0.4, 0.4, "Banco", true)
    
    -- Botões principais
    local btnSaldo = guiCreateButton(0.1, 0.2, 0.2, 0.1, "Ver Saldo", true, window)
    local btnDeposito = guiCreateButton(0.1, 0.35, 0.2, 0.1, "Depositar", true, window)
    local btnSaque = guiCreateButton(0.1, 0.5, 0.2, 0.1, "Sacar", true, window)
    
    -- Lista de transações
    local gridTransacoes = guiCreateGridList(0.35, 0.2, 0.6, 0.7, true, window)
end
```

## 3. Features Extras

### 3.1 Sistema de Juros
Add um sistema q:
- Calcula juros por tempo
- Tem diferentes taxas
- Tem bônus por tempo

```lua
-- Sistema de juros
function calcularJuros(valor, tempo)
    local taxa = 0.05 -- 5% base
    return valor * (1 + taxa * tempo)
end
```

### 3.2 Empréstimos
Sistema de empréstimo q:
- Verifica score
- Calcula parcelas
- Cobra juros
- Tem limite

```lua
-- Sistema de empréstimo
function pedirEmprestimo(player, valor)
    local score = getPlayerScore(player)
    local limite = score * 1000
    
    if valor > limite then
        return false, "Limite insuficiente"
    end
    
    -- Processar empréstimo
end
```

## 4. Segurança

### 4.1 Validações
Sempre verifique:
- PIN correto
- Saldo suficiente
- Limites diários
- Anti-exploit

```lua
-- Validações
function validarTransacao(player, valor)
    if valor <= 0 then return false end
    if valor > getLimiteTransacao(player) then return false end
    return true
end
```

### 4.2 Logs
Guarde logs de:
- Todas transações
- Tentativas falhas
- Acessos suspeitos
- Erros do sistema

```lua
-- Sistema de log
function logTransacao(tipo, dados)
    local timestamp = os.time()
    -- Salvar log
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
2. Valide dados
3. Trate erros
4. Faça backup

### 5.3 Organização
1. Comente bem
2. Use funções claras
3. Separe em módulos
4. Documente tudo

## 6. Extras

### 6.1 Features Legais
- Cartão de crédito
- Investimentos
- Transferência PIX
- App mobile

### 6.2 Segurança Extra
- 2FA
- Senha forte
- Timeout
- Blacklist

## 7. Próximos Passos

Depois q terminar:
1. Teste tudo
2. Otimize
3. Add features
4. Atualize sempre

Lembra:
- Teste bastante
- Backup sempre
- Segurança primeiro
- Divirta-se!

# Exercício: Sistema de Banco

## Objetivo
Criar um sistema completo de banco com as seguintes funcionalidades:
- Contas bancárias para jogadores
- Depósito e saque
- Transferências entre contas
- Extrato de transações
- Interface gráfica para operações

## Requisitos

### 1. Sistema de Contas
```lua
local BankSystem = {
    contas = {},
    
    criarConta = function(self, player)
        local account = getPlayerAccount(player)
        if not account then return false end
        
        local accountName = getAccountName(account)
        
        if self.contas[accountName] then
            return false
        end
        
        self.contas[accountName] = {
            saldo = 1000, -- Saldo inicial
            transacoes = {},
            ultimoAcesso = getTickCount()
        }
        
        return true
    end,
    
    getSaldo = function(self, player)
        local conta = self:getConta(player)
        return conta and conta.saldo or 0
    end,
    
    depositar = function(self, player, valor)
        if valor <= 0 then return false end
        
        local conta = self:getConta(player)
        if not conta then return false end
        
        -- Remove dinheiro do jogador
        if not takePlayerMoney(player, valor) then
            return false
        end
        
        -- Adiciona ao banco
        conta.saldo = conta.saldo + valor
        
        -- Registra transação
        self:registrarTransacao(player, "deposito", valor)
        
        return true
    end,
    
    sacar = function(self, player, valor)
        if valor <= 0 then return false end
        
        local conta = self:getConta(player)
        if not conta then return false end
        
        if conta.saldo < valor then
            return false
        end
        
        -- Remove do banco
        conta.saldo = conta.saldo - valor
        
        -- Adiciona ao jogador
        givePlayerMoney(player, valor)
        
        -- Registra transação
        self:registrarTransacao(player, "saque", -valor)
        
        return true
    end,
    
    transferir = function(self, player, alvo, valor)
        if valor <= 0 then return false end
        
        local contaOrigem = self:getConta(player)
        local contaDestino = self:getConta(alvo)
        
        if not contaOrigem or not contaDestino then
            return false
        end
        
        if contaOrigem.saldo < valor then
            return false
        end
        
        -- Transfere
        contaOrigem.saldo = contaOrigem.saldo - valor
        contaDestino.saldo = contaDestino.saldo + valor
        
        -- Registra transações
        self:registrarTransacao(player, "transferencia", -valor, 
            getPlayerName(alvo))
        self:registrarTransacao(alvo, "transferencia", valor,
            getPlayerName(player))
        
        return true
    end,
    
    registrarTransacao = function(self, player, tipo, valor, extra)
        local conta = self:getConta(player)
        if not conta then return end
        
        table.insert(conta.transacoes, {
            tipo = tipo,
            valor = valor,
            extra = extra,
            data = getTickCount()
        })
        
        -- Limita histórico
        if #conta.transacoes > 50 then
            table.remove(conta.transacoes, 1)
        end
    end,
    
    getExtrato = function(self, player)
        local conta = self:getConta(player)
        return conta and conta.transacoes or {}
    end,
    
    getConta = function(self, player)
        local account = getPlayerAccount(player)
        if not account then return nil end
        
        local accountName = getAccountName(account)
        return self.contas[accountName]
    end
}
```

### 2. Interface Gráfica
```lua
-- Cliente
local BankGUI = {
    window = nil,
    
    show = function(self)
        if self.window then return end
        
        -- Cria janela
        self.window = guiCreateWindow(0.3, 0.3, 0.4, 0.4, "Banco", true)
        
        -- Tabs
        local tabPanel = guiCreateTabPanel(0.02, 0.08, 0.96, 0.9, true, self.window)
        
        -- Tab Saldo
        local tabSaldo = guiCreateTab("Saldo", tabPanel)
        self:criarTabSaldo(tabSaldo)
        
        -- Tab Operações
        local tabOperacoes = guiCreateTab("Operações", tabPanel)
        self:criarTabOperacoes(tabOperacoes)
        
        -- Tab Extrato
        local tabExtrato = guiCreateTab("Extrato", tabPanel)
        self:criarTabExtrato(tabExtrato)
        
        -- Mostra cursor
        showCursor(true)
    end,
    
    hide = function(self)
        if not self.window then return end
        
        destroyElement(self.window)
        self.window = nil
        
        showCursor(false)
    end,
    
    criarTabSaldo = function(self, tab)
        local labelSaldo = guiCreateLabel(0.1, 0.1, 0.8, 0.1,
            "Seu saldo: $0", true, tab)
            
        -- Atualiza saldo
        triggerServerEvent("onRequestSaldo", localPlayer)
        
        addEventHandler("onClientSaldoUpdate", root,
            function(saldo)
                guiSetText(labelSaldo, "Seu saldo: $" .. saldo)
            end
        )
    end,
    
    criarTabOperacoes = function(self, tab)
        -- Valor
        guiCreateLabel(0.1, 0.1, 0.2, 0.1, "Valor:", true, tab)
        local editValor = guiCreateEdit(0.3, 0.1, 0.3, 0.1, "", true, tab)
        
        -- Alvo (para transferência)
        guiCreateLabel(0.1, 0.25, 0.2, 0.1, "Alvo:", true, tab)
        local editAlvo = guiCreateEdit(0.3, 0.25, 0.3, 0.1, "", true, tab)
        
        -- Botões
        local btnDepositar = guiCreateButton(0.1, 0.4, 0.2, 0.1,
            "Depositar", true, tab)
        local btnSacar = guiCreateButton(0.35, 0.4, 0.2, 0.1,
            "Sacar", true, tab)
        local btnTransferir = guiCreateButton(0.6, 0.4, 0.2, 0.1,
            "Transferir", true, tab)
            
        -- Handlers
        addEventHandler("onClientGUIClick", btnDepositar,
            function()
                local valor = tonumber(guiGetText(editValor))
                if not valor then return end
                
                triggerServerEvent("onBankDeposit", localPlayer, valor)
            end
        )
        
        addEventHandler("onClientGUIClick", btnSacar,
            function()
                local valor = tonumber(guiGetText(editValor))
                if not valor then return end
                
                triggerServerEvent("onBankWithdraw", localPlayer, valor)
            end
        )
        
        addEventHandler("onClientGUIClick", btnTransferir,
            function()
                local valor = tonumber(guiGetText(editValor))
                local alvo = guiGetText(editAlvo)
                if not valor or alvo == "" then return end
                
                triggerServerEvent("onBankTransfer", localPlayer, alvo, valor)
            end
        )
    end,
    
    criarTabExtrato = function(self, tab)
        local gridlist = guiCreateGridList(0.05, 0.05, 0.9, 0.9, true, tab)
        
        guiGridListAddColumn(gridlist, "Tipo", 0.2)
        guiGridListAddColumn(gridlist, "Valor", 0.2)
        guiGridListAddColumn(gridlist, "Data", 0.3)
        guiGridListAddColumn(gridlist, "Extra", 0.3)
        
        -- Atualiza extrato
        triggerServerEvent("onRequestExtrato", localPlayer)
        
        addEventHandler("onClientExtratoUpdate", root,
            function(extrato)
                guiGridListClear(gridlist)
                
                for _, transacao in ipairs(extrato) do
                    local row = guiGridListAddRow(gridlist)
                    guiGridListSetItemText(gridlist, row, 1, transacao.tipo, false, false)
                    guiGridListSetItemText(gridlist, row, 2, tostring(transacao.valor), false, false)
                    guiGridListSetItemText(gridlist, row, 3, 
                        os.date("%d/%m/%Y %H:%M", transacao.data), false, false)
                    guiGridListSetItemText(gridlist, row, 4, 
                        transacao.extra or "", false, false)
                end
            end
        )
    end
}

-- Bind para abrir/fechar
bindKey("F6", "down",
    function()
        if BankGUI.window then
            BankGUI:hide()
        else
            BankGUI:show()
        end
    end
)
```

### 3. Eventos e Comandos
```lua
-- Servidor
addEvent("onRequestSaldo", true)
addEventHandler("onRequestSaldo", root,
    function()
        local saldo = BankSystem:getSaldo(client)
        triggerClientEvent(client, "onClientSaldoUpdate", client, saldo)
    end
)

addEvent("onRequestExtrato", true)
addEventHandler("onRequestExtrato", root,
    function()
        local extrato = BankSystem:getExtrato(client)
        triggerClientEvent(client, "onClientExtratoUpdate", client, extrato)
    end
)

addEvent("onBankDeposit", true)
addEventHandler("onBankDeposit", root,
    function(valor)
        if BankSystem:depositar(client, valor) then
            outputChatBox("Depósito de $" .. valor .. " realizado!", client, 0, 255, 0)
            triggerClientEvent(client, "onClientSaldoUpdate", client,
                BankSystem:getSaldo(client))
        else
            outputChatBox("Erro ao depositar!", client, 255, 0, 0)
        end
    end
)

addEvent("onBankWithdraw", true)
addEventHandler("onBankWithdraw", root,
    function(valor)
        if BankSystem:sacar(client, valor) then
            outputChatBox("Saque de $" .. valor .. " realizado!", client, 0, 255, 0)
            triggerClientEvent(client, "onClientSaldoUpdate", client,
                BankSystem:getSaldo(client))
        else
            outputChatBox("Erro ao sacar!", client, 255, 0, 0)
        end
    end
)

addEvent("onBankTransfer", true)
addEventHandler("onBankTransfer", root,
    function(alvo, valor)
        local targetPlayer = getPlayerFromName(alvo)
        if not targetPlayer then
            outputChatBox("Jogador não encontrado!", client, 255, 0, 0)
            return
        end
        
        if BankSystem:transferir(client, targetPlayer, valor) then
            outputChatBox("Transferência de $" .. valor .. " para " .. 
                alvo .. " realizada!", client, 0, 255, 0)
            outputChatBox("Você recebeu $" .. valor .. " de " ..
                getPlayerName(client), targetPlayer, 0, 255, 0)
                
            triggerClientEvent(client, "onClientSaldoUpdate", client,
                BankSystem:getSaldo(client))
            triggerClientEvent(targetPlayer, "onClientSaldoUpdate", targetPlayer,
                BankSystem:getSaldo(targetPlayer))
        else
            outputChatBox("Erro ao transferir!", client, 255, 0, 0)
        end
    end
)

-- Comandos
addCommandHandler("criarconta",
    function(player)
        if BankSystem:criarConta(player) then
            outputChatBox("Conta bancária criada!", player, 0, 255, 0)
        else
            outputChatBox("Erro ao criar conta!", player, 255, 0, 0)
        end
    end
)
```

## Desafios Extras

1. Adicione juros diários para contas com saldo positivo

2. Implemente um sistema de empréstimos com:
   - Limite baseado no histórico
   - Juros por tempo
   - Pagamento automático

3. Crie um sistema de investimentos com:
   - Diferentes tipos (CDB, Ações, etc)
   - Rentabilidade variável
   - Interface para acompanhamento

4. Adicione um sistema de cartão de crédito com:
   - Limite
   - Fatura mensal
   - Pagamento mínimo

## Dicas

1. Use XML ou JSON para salvar dados permanentemente

2. Implemente logs detalhados de todas as operações

3. Adicione confirmações para operações importantes

4. Crie uma API documentada para outros recursos usarem

## Avaliação

Seu sistema será avaliado nos seguintes aspectos:

1. Funcionalidade
   - Todas as operações funcionam corretamente
   - Sistema previne erros e abusos
   - Dados são salvos corretamente

2. Interface
   - GUI clara e intuitiva
   - Feedback adequado ao usuário
   - Tratamento de erros amigável

3. Código
   - Bem organizado e comentado
   - Eficiente e otimizado
   - Seguro e robusto

4. Extras
   - Funcionalidades adicionais
   - Inovações no sistema
   - Documentação clara
