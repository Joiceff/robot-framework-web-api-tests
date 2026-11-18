# 🤖 Robot Framework — Automação Web + API

[![Robot Framework Tests](https://github.com/Joiceff/robot-framework-web-api-tests/actions/workflows/tests.yml/badge.svg)](https://github.com/Joiceff/robot-framework-web-api-tests/actions/workflows/tests.yml)

Projeto de automação de testes com **Robot Framework** cobrindo duas camadas:

- **Web (E2E):** aplicação [SauceDemo](https://www.saucedemo.com) com SeleniumLibrary
- **API REST:** [ServeRest](https://serverest.dev) com RequestsLibrary

## 🧰 Tecnologias

| Ferramenta | Uso |
|---|---|
| Robot Framework 7 | Framework de testes (keyword-driven) |
| SeleniumLibrary | Automação web (Chrome headless) |
| RequestsLibrary | Testes de API REST |
| FakerLibrary | Massa de dados dinâmica (pt_BR) |
| GitHub Actions | Execução contínua (CI) em matriz `api` / `web` |

## 📁 Estrutura

```
├── resources/
│   ├── api/serverest.resource     # keywords da API (sessão, usuários, login, produtos)
│   └── web/saucedemo.resource     # locators + keywords da aplicação web
├── tests/
│   ├── api/usuarios.robot         # CRUD de usuários e validações
│   ├── api/login_produtos.robot   # autenticação, autorização e produtos
│   └── web/saucedemo.robot        # login, carrinho, checkout e ordenação
└── .github/workflows/tests.yml    # pipeline CI
```

## ✅ Cenários cobertos

**API (11 testes)**
- Cadastro de usuário válido, e-mail duplicado e campos obrigatórios (*data-driven com `[Template]`*)
- Consulta e exclusão de usuário; usuário inexistente
- Login com sucesso (token Bearer) e credenciais inválidas
- Cadastro de produto por administrador, sem token (401) e por usuário comum (403)
- Limpeza dos dados criados em `[Teardown]` — testes independentes

**Web (6 testes)**
- Login válido, usuário bloqueado e senha inválida
- Adição de produtos ao carrinho
- Fluxo completo de compra (checkout)
- Ordenação de produtos por preço

## ▶️ Como executar

```bash
pip install -r requirements.txt

# todos os testes
robot --outputdir results tests

# apenas API ou apenas Web
robot --outputdir results tests/api
robot --outputdir results tests/web

# por tag
robot --include smoke --outputdir results tests
```

Os relatórios `report.html` e `log.html` ficam em `results/`. No GitHub Actions, eles são publicados como *artifacts* de cada execução.

---
👩‍💻 Desenvolvido por **Joice Ferreira** — QA Sênior | [LinkedIn](https://www.linkedin.com/in/joice-ferreira-a04227126)
