*** Settings ***
Documentation       Testes de API do recurso /usuarios da ServeRest.
Resource            ../../resources/api/serverest.resource
Library             Collections
Suite Setup         Criar Sessao Na API
Test Tags           api    usuarios


*** Test Cases ***
CT01 - Cadastrar usuario com dados validos
    [Tags]    smoke
    ${usuario}=     Gerar Dados De Usuario
    ${resposta}=    Cadastrar Usuario    ${usuario}
    Validar Mensagem Da Resposta    ${resposta}    Cadastro realizado com sucesso
    Dictionary Should Contain Key    ${resposta.json()}    _id
    [Teardown]    Excluir Usuario    ${resposta.json()}[_id]

CT02 - Nao permitir cadastro com email duplicado
    ${usuario}=     Cadastrar Novo Usuario Valido
    ${duplicado}=   Copy Dictionary    ${usuario}
    Remove From Dictionary    ${duplicado}    _id
    ${resposta}=    Cadastrar Usuario    ${duplicado}    status_esperado=400
    Validar Mensagem Da Resposta    ${resposta}    Este email já está sendo usado
    [Teardown]    Excluir Usuario    ${usuario}[_id]

CT03 - Buscar usuario cadastrado por id
    ${usuario}=     Cadastrar Novo Usuario Valido
    ${resposta}=    Buscar Usuario Por Id    ${usuario}[_id]
    Should Be Equal    ${resposta.json()}[nome]     ${usuario}[nome]
    Should Be Equal    ${resposta.json()}[email]    ${usuario}[email]
    [Teardown]    Excluir Usuario    ${usuario}[_id]

CT04 - Buscar usuario inexistente
    ${resposta}=    Buscar Usuario Por Id    idInexistente123    status_esperado=400
    Validar Mensagem Da Resposta    ${resposta}    Usuário não encontrado

CT05 - Excluir usuario cadastrado
    ${usuario}=     Cadastrar Novo Usuario Valido
    ${resposta}=    Excluir Usuario    ${usuario}[_id]
    Validar Mensagem Da Resposta    ${resposta}    Registro excluído com sucesso
    Buscar Usuario Por Id    ${usuario}[_id]    status_esperado=400

CT06 - Validar campos obrigatorios no cadastro
    [Template]    Cadastro Sem Campo Obrigatorio
    nome
    email
    password


*** Keywords ***
Cadastro Sem Campo Obrigatorio
    [Arguments]    ${campo}
    ${usuario}=     Gerar Dados De Usuario
    Set To Dictionary    ${usuario}    ${campo}=${EMPTY}
    ${resposta}=    Cadastrar Usuario    ${usuario}    status_esperado=400
    Should Be Equal As Strings    ${resposta.json()}[${campo}]    ${campo} não pode ficar em branco
