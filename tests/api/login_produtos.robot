*** Settings ***
Documentation       Testes de API de autenticação (/login) e produtos (/produtos) da ServeRest.
Resource            ../../resources/api/serverest.resource
Suite Setup         Criar Sessao Na API
Test Tags           api


*** Test Cases ***
CT07 - Login com credenciais validas retorna token
    [Tags]    smoke    login
    ${usuario}=     Cadastrar Novo Usuario Valido
    ${resposta}=    Realizar Login    ${usuario}[email]    ${usuario}[password]
    Validar Mensagem Da Resposta    ${resposta}    Login realizado com sucesso
    Should Start With    ${resposta.json()}[authorization]    Bearer
    [Teardown]    Excluir Usuario    ${usuario}[_id]

CT08 - Login com senha invalida
    [Tags]    login
    ${usuario}=     Cadastrar Novo Usuario Valido
    ${resposta}=    Realizar Login    ${usuario}[email]    senhaErrada123    status_esperado=401
    Validar Mensagem Da Resposta    ${resposta}    Email e/ou senha inválidos
    [Teardown]    Excluir Usuario    ${usuario}[_id]

CT09 - Administrador cadastra produto com sucesso
    [Tags]    smoke    produtos
    ${token}=       Obter Token De Administrador
    ${produto}=     Gerar Dados De Produto
    ${resposta}=    Cadastrar Produto    ${produto}    ${token}
    Validar Mensagem Da Resposta    ${resposta}    Cadastro realizado com sucesso
    [Teardown]    Run Keywords
    ...    Excluir Produto    ${resposta.json()}[_id]    ${token}
    ...    AND    Excluir Usuario    ${USUARIO_ADMIN}[_id]

CT10 - Nao permitir cadastro de produto sem token
    [Tags]    produtos    seguranca
    ${produto}=     Gerar Dados De Produto
    ${resposta}=    Cadastrar Produto    ${produto}    status_esperado=401
    Validar Mensagem Da Resposta    ${resposta}
    ...    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

CT11 - Usuario comum nao pode cadastrar produto
    [Tags]    produtos    seguranca
    ${usuario}=     Cadastrar Novo Usuario Valido    administrador=false
    ${login}=       Realizar Login    ${usuario}[email]    ${usuario}[password]
    ${produto}=     Gerar Dados De Produto
    ${resposta}=    Cadastrar Produto    ${produto}    ${login.json()}[authorization]    status_esperado=403
    Validar Mensagem Da Resposta    ${resposta}    Rota exclusiva para administradores
    [Teardown]    Excluir Usuario    ${usuario}[_id]
