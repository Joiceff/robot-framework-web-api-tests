*** Settings ***
Documentation       Keywords e locators da aplicação web SauceDemo (https://www.saucedemo.com).
Library             SeleniumLibrary    timeout=10s    implicit_wait=0s
Library             Collections


*** Variables ***
${URL}                  https://www.saucedemo.com
${BROWSER}              headlesschrome
${SENHA_PADRAO}         secret_sauce

# Locators
${CAMPO_USUARIO}        id=user-name
${CAMPO_SENHA}          id=password
${BOTAO_LOGIN}          id=login-button
${MENSAGEM_ERRO}        css=[data-test="error"]
${TITULO_PAGINA}        css=[data-test="title"]
${BADGE_CARRINHO}       css=[data-test="shopping-cart-badge"]
${LINK_CARRINHO}        css=[data-test="shopping-cart-link"]
${BOTAO_CHECKOUT}       id=checkout
${CAMPO_NOME}           id=first-name
${CAMPO_SOBRENOME}      id=last-name
${CAMPO_CEP}            id=postal-code
${BOTAO_CONTINUAR}      id=continue
${BOTAO_FINALIZAR}      id=finish
${MENSAGEM_SUCESSO}     css=[data-test="complete-header"]
${ORDENACAO}            css=[data-test="product-sort-container"]
${PRECOS_PRODUTOS}      css=[data-test="inventory-item-price"]


*** Keywords ***
Abrir Navegador Na Pagina De Login
    ${options}=    Evaluate    selenium.webdriver.ChromeOptions()    modules=selenium.webdriver
    Call Method    ${options}    add_argument    --window-size\=1366,768
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Open Browser    ${URL}    ${BROWSER}    options=${options}

Fechar Navegador
    Capture Page Screenshot
    Close Browser

Fazer Login
    [Arguments]    ${usuario}    ${senha}=${SENHA_PADRAO}
    Input Text        ${CAMPO_USUARIO}    ${usuario}
    Input Password    ${CAMPO_SENHA}      ${senha}
    Click Button      ${BOTAO_LOGIN}

Validar Que Esta Na Pagina De Produtos
    Wait Until Element Contains    ${TITULO_PAGINA}    Products

Validar Mensagem De Erro
    [Arguments]    ${mensagem}
    Wait Until Element Contains    ${MENSAGEM_ERRO}    ${mensagem}

Adicionar Produto Ao Carrinho
    [Arguments]    ${id_produto}
    Click Button    id=add-to-cart-${id_produto}

Validar Quantidade No Carrinho
    [Arguments]    ${quantidade}
    Wait Until Element Contains    ${BADGE_CARRINHO}    ${quantidade}

Finalizar Compra
    [Arguments]    ${nome}    ${sobrenome}    ${cep}
    Click Element     ${LINK_CARRINHO}
    Wait Until Element Is Visible    ${BOTAO_CHECKOUT}
    Click Button      ${BOTAO_CHECKOUT}
    Wait Until Element Is Visible    ${CAMPO_NOME}
    Input Text        ${CAMPO_NOME}         ${nome}
    Input Text        ${CAMPO_SOBRENOME}    ${sobrenome}
    Input Text        ${CAMPO_CEP}          ${cep}
    Click Button      ${BOTAO_CONTINUAR}
    Wait Until Element Is Visible    ${BOTAO_FINALIZAR}
    Click Button      ${BOTAO_FINALIZAR}

Ordenar Produtos Por
    [Arguments]    ${opcao}
    Select From List By Value    ${ORDENACAO}    ${opcao}

Obter Precos Dos Produtos
    ${elementos}=    Get WebElements    ${PRECOS_PRODUTOS}
    ${precos}=    Create List
    FOR    ${elemento}    IN    @{elementos}
        ${texto}=    Get Text    ${elemento}
        ${valor}=    Evaluate    float("${texto}".replace("$", ""))
        Append To List    ${precos}    ${valor}
    END
    RETURN    ${precos}
