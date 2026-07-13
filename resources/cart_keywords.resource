*** Settings ***
Library     SeleniumLibrary
Resource    locators.resource
Resource    login_keywords.resource

*** Keywords ***
Add Backpack To Cart
    Click Button    ${BACKPACK_ADD_BUTTON}
    Element Text Should Be    ${CART_BADGE}    1

Open Shopping Cart
    Click Element    ${SHOPPING_CART}

Checkout With Details
    [Arguments]    ${first}    ${last}    ${zip}

    Click Button    ${CHECKOUT_BUTTON}

    Input Text    ${FIRST_NAME}    ${first}
    Input Text    ${LAST_NAME}     ${last}
    Input Text    ${POSTAL_CODE}   ${zip}

    Click Button    ${CONTINUE_BUTTON}

Finish Checkout
    Click Button    ${FINISH_BUTTON}

Order Should Complete
    Wait Until Element Is Visible    ${COMPLETE_HEADER}
    Element Text Should Be    ${COMPLETE_HEADER}    Thank you for your order!