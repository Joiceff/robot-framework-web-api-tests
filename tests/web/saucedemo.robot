*** Settings ***
Documentation       Testes E2E da aplicação SauceDemo: login, carrinho, checkout e ordenação.
Resource            ../../resources/web/saucedemo.resource
Library             Collections
Test Setup          Abrir Navegador Na Pagina De Login
Test Teardown       Fechar Navegador
Test Tags           web


*** Test Cases ***
CT01 - Login com usuario valido
    [Tags]    smoke    login
    Fazer Login    standard_user
    Validar Que Esta Na Pagina De Produtos

CT02 - Login com usuario bloqueado
    [Tags]    login
    Fazer Login    locked_out_user
    Validar Mensagem De Erro    Sorry, this user has been locked out.

CT03 - Login com senha invalida
    [Tags]    login
    Fazer Login    standard_user    senha_errada
    Validar Mensagem De Erro    Username and password do not match any user in this service

CT04 - Adicionar produtos ao carrinho
    [Tags]    carrinho
    Fazer Login    standard_user
    Adicionar Produto Ao Carrinho    sauce-labs-backpack
    Adicionar Produto Ao Carrinho    sauce-labs-bike-light
    Validar Quantidade No Carrinho    2

CT05 - Realizar compra completa (checkout)
    [Tags]    smoke    checkout
    Fazer Login    standard_user
    Adicionar Produto Ao Carrinho    sauce-labs-backpack
    Finalizar Compra    Joice    QA    14800-000
    Wait Until Element Contains    ${MENSAGEM_SUCESSO}    Thank you for your order!

CT06 - Ordenar produtos por menor preco
    [Tags]    ordenacao
    Fazer Login    standard_user
    Ordenar Produtos Por    lohi
    ${precos}=    Obter Precos Dos Produtos
    ${ordenados}=    Copy List    ${precos}
    Sort List    ${ordenados}
    Lists Should Be Equal    ${precos}    ${ordenados}
