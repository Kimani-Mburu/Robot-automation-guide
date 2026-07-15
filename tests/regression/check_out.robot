*** Settings ***
Documentation         Test Suit for login in checkin and item to cart and checking out.
# Documentation        Regression checks for the SauceDemo login page: multiple
# ...                   valid accounts, invalid credentials, and edge cases.
Library               SeleniumLibrary
Library               ../../resources/CsvLibrary.py
Resource              ../../resources/login_keywords.resource
Resource              ../../resources/check_out_keywords.resource
Suite Setup           Open Login Page
Suite Teardown        Close All Browsers
Test Setup            Reset To Login Page

*** Variables ***
# "chrome" opens a visible browser window. Override with
# "--variable BROWSER:headlesschrome" for CI or headless runs.
${BROWSER}    chrome


*** Test Cases ***

Add An Item To Cart And Checkout
    # [Documentation]        User should be able to add an item to cart and checkout
    # Wait Until Element Is Visible    ${INVENTORY_TITLE}    timeout=10s
    Login Should Succeed    standard_user    secret_sauce
    Add Item To Cart
    Go T0 Checkout Page
    Click On Checkout
    Enter Checkout Information 
    Click On Continue At Checkout
    Click on Finish 


    