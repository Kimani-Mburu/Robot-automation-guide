*** Settings ***
Resource    ../../resources/login_keywords.resource
Resource    ../../resources/cart_keywords.resource

Suite Setup       Open Login Page
Suite Teardown    Close Browser
Test Setup        Reset To Login Page

*** Variables ***
${BROWSER}    chrome

*** Test Cases ***
Standard User Can Purchase One Item
    [Documentation]    Logs in, adds an item to the cart, completes checkout, and verifies the order succeeds.

    Login Should Succeed    standard_user    secret_sauce

    Add Backpack To Cart

    Open Shopping Cart

    Checkout With Details
    ...    John
    ...    Doe
    ...    90210

    Finish Checkout

    Order Should Complete