# Introdução à Lua e MTA:SA
---

## O que é Lua?

* Linguagem de programação brasileira
* Criada na PUC-Rio
* Leve e poderosa
* Amplamente usada em jogos

---

## Por que Lua?

* Fácil de aprender
* Rápida execução
* Flexível
* Integração simples

---

## MTA:SA e Lua

* MTA usa Lua como linguagem principal
* Permite criar modos de jogo completos
* Grande comunidade de desenvolvedores
* Documentação rica

---

## Ambiente de Desenvolvimento

* Editor recomendado: VSCode
* Extensões úteis:
  * Lua Language Server
  * MTA-Lua
  * Markdown Preview

---

## Primeiros Passos

```lua
-- Seu primeiro script
addEventHandler("onResourceStart", resourceRoot,
    function()
        outputChatBox("Olá, Mundo!")
    end
)
```
