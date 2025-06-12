# Entendendo o meta.xml no MTA:SA - Guia Simplificado

## O q vc vai encontrar aqui
1. [Pra q serve](#1-pra-q-serve)
2. [Como montar](#2-como-montar)
3. [Tags importantes](#3-tags-importantes)
4. [Configs q vc precisa saber](#4-configs-importantes)
5. [Exemplos práticos](#5-exemplos-práticos)
6. [Dicas úteis](#6-dicas-úteis)
7. [Resolvendo problemas](#7-resolvendo-problemas)

## 1. Pra q serve

O `meta.xml` é o arquivo mais importante do seu mod no MTA:SA. Ele controla:
- Quais arquivos seu mod usa
- Do q seu mod precisa pra funcionar
- Como seu mod se comporta
- Quem pode fazer o q
- Info sobre seu mod

## 2. Como montar

### 2.1 Modelo básico
```xml
<meta>
    <info author="Seu Nome" type="gamemode" name="Nome do Mod" version="1.0.0"/>
    <script src="server.lua" type="server"/>
    <script src="client.lua" type="client" cache="false"/>
</meta>
```

### 2.2 O q não pode faltar
- Tag `<meta>` - É onde tudo fica
- Tag `<info>` - Info básica do seu mod
- Pelo menos um arquivo de script

## 3. Tags importantes

### 3.1 `<info>`
```xml
<info 
    author="Seu Nome" 
    type="gamemode" 
    name="Nome do Mod" 
    version="1.0.0" 
    description="O q seu mod faz"
/>
```

#### O q cada coisa significa
- `author`: Quem fez o mod
- `type`: Se é um gamemode ou script normal
- `name`: Nome do seu mod
- `version`: Versão atual
- `description`: Explicação rápida do q ele faz

### 3.2 `<script>`
```xml
<script src="arquivo.lua" type="server"/>
<script src="interface.lua" type="client" cache="false"/>
```

#### Configs importantes
- `src`: Onde tá o arquivo
- `type`: Se roda no server ou no client
- `cache`: Se precisa atualizar sempre q muda

### 3.3 `<file>`
```xml
<file src="imagens/logo.png"/>
<file src="sons/musica.mp3"/>
```

#### Pra q serve
- Arquivos q seu mod usa (imagens, sons, etc)
- Só funciona no client
- Pode usar em scripts client

### 3.4 `<export>`
```xml
<export function="minhaFuncao" type="server"/>
<export function="outraFuncao" type="client"/>
```

#### Como usar
- Funções q outros mods podem usar
- Pode ser do server ou client
- Precisa marcar como exported no código

## 4. Configs importantes

### 4.1 Dependências
```xml
<include resource="outro_mod"/>
<include resource="biblioteca"/>
```

### 4.2 Permissões
```xml
<aclrequest>
    <right name="function.kickPlayer" access="true"/>
</aclrequest>
```

### 4.3 Configs do mod
```xml
<settings>
    <setting name="max_players" value="32"/>
    <setting name="welcome_message" value="Bem vindo!"/>
</settings>
```

## 5. Exemplos práticos

### 5.1 Mod básico
```xml
<meta>
    <info author="Vc" type="script" name="Mod Legal" version="1.0"/>
    <script src="server.lua" type="server"/>
    <script src="client.lua" type="client"/>
    <file src="imagens/ui.png"/>
</meta>
```

### 5.2 Mod mais completo
```xml
<meta>
    <info author="Vc" type="gamemode" name="Super Mod" version="1.0"/>
    
    <!-- Scripts -->
    <script src="server/main.lua" type="server"/>
    <script src="client/interface.lua" type="client"/>
    
    <!-- Arquivos -->
    <file src="imagens/logo.png"/>
    <file src="sons/musica.mp3"/>
    
    <!-- Funções q outros podem usar -->
    <export function="getPontos" type="server"/>
    
    <!-- Precisa de outros mods -->
    <include resource="scoreboard"/>
    
    <!-- Configs -->
    <settings>
        <setting name="tempo_respawn" value="5"/>
    </settings>
</meta>
```

## 6. Dicas úteis

1. Sempre coloque uma descrição boa
2. Use nomes q fazem sentido pros arquivos
3. Organize em pastas se tiver mtos arquivos
4. Não esqueça das dependências
5. Só exporte oq outros mods precisam mesmo

## 7. Resolvendo problemas

### Problemas comuns
1. "Arquivo não encontrado"
   - Confira se o caminho tá certo
   - Veja se o arquivo existe mesmo

2. "Função não encontrada"
   - Veja se exportou a função
   - Confira se o nome tá igual

3. "Dependência faltando"
   - Instale o mod q falta
   - Confira se o nome tá certo

4. "Permissão negada"
   - Adicione as permissões no ACL
   - Use aclrequest se precisar

### Como resolver
1. Confira o log do servidor
2. Veja se todos os arquivos existem
3. Teste as dependências
4. Verifique as permissões
