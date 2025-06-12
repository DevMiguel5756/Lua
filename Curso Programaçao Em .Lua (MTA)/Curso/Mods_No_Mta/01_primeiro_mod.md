# Criando Seu Primeiro Mod no MTA:SA

## Passo 1: Estrutura do Mod

1. Crie uma pasta com o nome do seu mod (exemplo: `meu_primeiro_mod`)
2. Dentro dela, crie os seguintes arquivos:
   - `meta.xml` (configuração do mod)
   - `server.lua` (código do servidor)
   - `client.lua` (código do cliente)

## Passo 2: Configurando o meta.xml

1. Abra o `meta.xml` e adicione o seguinte código:
```xml
<meta>
    <info author="Seu Nome" type="gamemode" name="Meu Primeiro Mod" />
    <script src="server.lua" type="server" />
    <script src="client.lua" type="client" />
</meta>
```

## Passo 3: Criando o Código do Servidor

1. Abra `server.lua`
2. Adicione um evento de início:
```lua
addEventHandler("onResourceStart", resourceRoot,
    function()
        outputChatBox("Mod iniciado com sucesso!", root, 0, 255, 0)
    end
)
```

## Passo 4: Criando o Código do Cliente

1. Abra `client.lua`
2. Adicione um comando básico:
```lua
addCommandHandler("ola",
    function()
        outputChatBox("Olá! Este é meu primeiro mod!", 255, 255, 0)
    end
)
```

## Passo 5: Testando o Mod

1. Copie a pasta do mod para a pasta `resources` do seu servidor
2. Inicie o servidor MTA
3. Use o comando `start meu_primeiro_mod` no console
4. Entre no servidor e teste o comando `/ola`

## Próximos Passos

1. Adicione mais comandos
2. Experimente criar eventos entre servidor e cliente
3. Adicione elementos como veículos ou objetos
4. Implemente um sistema de pontuação simples
