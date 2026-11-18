*** Settings ***
Documentation       Keywords reutilizáveis para a API ServeRest (https://serverest.dev).
Library             RequestsLibrary
Library             FakerLibrary    locale=pt_BR
Library             Collections


*** Variables ***
${BASE_URL}         https://serverest.dev
${ALIAS}            serverest


*** Keywords ***
Criar Sessao Na API
    ${headers}=    Create Dictionary    Content-Type=application/json    accept=application/json
    Create Session    ${ALIAS}    ${BASE_URL}    headers=${headers}    verify=${True}

Gerar Dados De Usuario
    [Arguments]    ${administrador}=true
    ${nome}=     FakerLibrary.Name
    ${email}=    FakerLibrary.Email
    ${uuid}=     FakerLibrary.Uuid4
    ${email}=    Set Variable    qa_${uuid}_${email}
    ${senha}=    FakerLibrary.Password    length=10
    ${usuario}=    Create Dictionary
    ...    nome=${nome}
    ...    email=${email}
    ...    password=${senha}
    ...    administrador=${administrador}
    RETURN    ${usuario}

Cadastrar Usuario
    [Arguments]    ${usuario}    ${status_esperado}=201
    ${resposta}=    POST On Session    ${ALIAS}    /usuarios    json=${usuario}
    ...    expected_status=${status_esperado}
    RETURN    ${resposta}

Cadastrar Novo Usuario Valido
    [Arguments]    ${administrador}=true
    ${usuario}=     Gerar Dados De Usuario    ${administrador}
    ${resposta}=    Cadastrar Usuario    ${usuario}
    Set To Dictionary    ${usuario}    _id=${resposta.json()}[_id]
    RETURN    ${usuario}

Buscar Usuario Por Id
    [Arguments]    ${id}    ${status_esperado}=200
    ${resposta}=    GET On Session    ${ALIAS}    /usuarios/${id}    expected_status=${status_esperado}
    RETURN    ${resposta}

Excluir Usuario
    [Arguments]    ${id}
    ${resposta}=    DELETE On Session    ${ALIAS}    /usuarios/${id}    expected_status=200
    RETURN    ${resposta}

Realizar Login
    [Arguments]    ${email}    ${senha}    ${status_esperado}=200
    ${corpo}=       Create Dictionary    email=${email}    password=${senha}
    ${resposta}=    POST On Session    ${ALIAS}    /login    json=${corpo}    expected_status=${status_esperado}
    RETURN    ${resposta}

Obter Token De Administrador
    ${usuario}=     Cadastrar Novo Usuario Valido    administrador=true
    ${resposta}=    Realizar Login    ${usuario}[email]    ${usuario}[password]
    Set Test Variable    ${USUARIO_ADMIN}    ${usuario}
    RETURN    ${resposta.json()}[authorization]

Gerar Dados De Produto
    ${uuid}=        FakerLibrary.Uuid4
    ${nome}=        Set Variable    Produto QA ${uuid}
    ${descricao}=    FakerLibrary.Sentence    nb_words=5
    ${preco}=       FakerLibrary.Random Int    min=10    max=999
    ${quantidade}=    FakerLibrary.Random Int    min=1    max=100
    ${produto}=    Create Dictionary
    ...    nome=${nome}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${quantidade}
    RETURN    ${produto}

Cadastrar Produto
    [Arguments]    ${produto}    ${token}=${EMPTY}    ${status_esperado}=201
    ${headers}=    Create Dictionary    Authorization=${token}
    ${resposta}=    POST On Session    ${ALIAS}    /produtos    json=${produto}    headers=${headers}
    ...    expected_status=${status_esperado}
    RETURN    ${resposta}

Excluir Produto
    [Arguments]    ${id}    ${token}
    ${headers}=    Create Dictionary    Authorization=${token}
    DELETE On Session    ${ALIAS}    /produtos/${id}    headers=${headers}    expected_status=200

Validar Mensagem Da Resposta
    [Arguments]    ${resposta}    ${mensagem_esperada}
    Should Be Equal As Strings    ${resposta.json()}[message]    ${mensagem_esperada}
