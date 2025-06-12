# Introdução ao MTA:SA

Fala dev! Bora começar a aprender sobre o MTA:SA? Vamo nessa!

## 1. O que é o MTA:SA?

Multi Theft Auto: San Andreas (MTA:SA) é uma mod multiplayer pro GTA:SA que permite:
- Jogar online com galera
- Criar servers personalizados
- Programar scripts em Lua
- Modificar praticamente tudo no jogo

## 2. Por que usar MTA:SA?

### 2.1 Vantagens
- Fácil de aprender
- Comunidade grande e ativa
- Mta suporta mta scripts
- Documentação completa
- Mta tem API poderosa

### 2.2 Possibilidades
- RPG servers
- DM/TDM modes
- Corridas custom
- Minigames
- Modos únicos

## 3. Começando

### 3.1 Setup Básico
1. **Instala o MTA:SA**
   - Baixa do site oficial
   - Instala normalmente
   - Precisa do GTA:SA original

2. **Testa o Client**
   - Abre o MTA
   - Entra em qualquer server
   - Checa se tá rodando ok

3. **Setup de Dev**
   - IDE/editor de texto
   - Docs do MTA abertas
   - Server local pra teste

### 3.2 Primeiros Passos
1. **Aprende Lua**
   - Sintaxe básica
   - Funções
   - Tabelas
   - OOP em Lua

2. **Estuda API**
   - Funções client
   - Funções server
   - Eventos
   - Elementos

3. **Faz Testes**
   - Scripts simples
   - Testa no server
   - Debug e ajusta
   - Melhora aos poucos

## 4. Estrutura Básica

### 4.1 Scripts Client
```lua
-- Exemplo de script client
addEventHandler("onClientResourceStart", resourceRoot, function()
    -- Roda qnd resource inicia
    outputChatBox("Client script rodando!")
    
    -- Cria GUI simples
    local btn = guiCreateButton(0.4, 0.4, 0.2, 0.1, "Clica!", true)
    
    -- Handler do botão
    addEventHandler("onClientGUIClick", btn, function()
        outputChatBox("Clicou!")
    end, false)
end)
```

### 4.2 Scripts Server
```lua
-- Exemplo de script server
addEventHandler("onResourceStart", resourceRoot, function()
    -- Roda qnd resource inicia
    outputChatBox("Server script rodando!")
    
    -- Comando simples
    addCommandHandler("oi", function(player)
        outputChatBox("Oi " .. getPlayerName(player) .. "!", player)
    end)
end)
```

## 5. Dicas Importantes

### 5.1 Pra Começar
1. **Começa devagar**
   - Scripts simples
   - Testa mto
   - Aprende com erros
   - Evolui aos poucos

2. **Usa recursos**
   - Docs oficiais
   - Forums MTA
   - Exemplos prontos
   - Videos tutoriais

3. **Pratica**
   - Faz projetos
   - Testa ideias
   - Ajuda outros
   - Compartilha código

### 5.2 Boas Práticas
1. **Código**
   - Comenta bem
   - Organiza files
   - Nomeia direito
   - Otimiza qnd dá

2. **Debug**
   - Usa prints
   - Checa erros
   - Testa tudo
   - Fix bugs logo

3. **Segurança**
   - Valida inputs
   - Protege dados
   - Anti-cheat
   - Testa segurança

## 6. Próximos Passos

1. **Estuda mais**
   - API completa
   - Eventos MTA
   - Network
   - Otimização

2. **Faz projetos**
   - Começa pequeno
   - Aumenta aos poucos
   - Testa bastante
   - Pede feedback

3. **Participa**
   - Forums
   - Discord
   - GitHub
   - Comunidade
