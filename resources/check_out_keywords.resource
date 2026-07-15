*** Settings ***
Library     SeleniumLibrary
Resource    locators.resource


*** Keywords ***
# Add Item To Cart
#     [Documentation] 
#     ...    adding of an item to cart
#     Wait Until Element Is Visible    ${INVENTORY_TITLE}    timeout=10s
#     Wait Until Element Is Visible    ${ADD_TO_CART}    timeout=10s
#     Click Button    ${ADD_TO_CART}

Go T0 Checkout Page
    [Documentation] 
    ...    adding of an item to cart
    Click Element    ${Cart}
    Wait Until Element Is Visible    ${INVENTORY_TITLE}    timeout=10s
    Element Text Should Be    ${INVENTORY_TITLE}    Your Cart

Click On Checkout
    [Documentation]
    ...    Clicking on checkout
    Click Button    ${Checkout}
    Wait Until Element Is Visible    ${INVENTORY_TITLE}    timeout=10s
    Element Text Should Be    ${INVENTORY_TITLE}    Checkout: Your Information

Enter Checkout Information 
    [Documentation]
    ...    User enters checkout infor
    Input Text        ${firstName}    "Hammerton"
    Input Text        ${lastName}    "Mutuku"
    Input Text        ${PostalCode}    "929-00100"

Click On Continue At Checkout
    [Documentation]
    ...     User clicks on continue after entering details
    Click Button    id:continue   
    Wait Until Element Is Visible    ${INVENTORY_TITLE}    timeout=10s
    Element Text Should Be    ${INVENTORY_TITLE}    Checkout: Overview

Click on Finish 
    [Documentation]
    ...    User clicks on finish
    Click Button    id:finish
    Wait Until Element Is Visible    ${INVENTORY_TITLE}    timeout=10s
    Element Text Should Be    ${INVENTORY_TITLE}    Checkout: Complete!



