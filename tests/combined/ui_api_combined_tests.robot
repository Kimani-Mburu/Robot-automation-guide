*** Comments ***
# ------------------------------------------------------------------------------
# ui_api_combined_tests.robot
#
# What this file is for:
#   The full "create via API, log in via UI" pattern (Sections 4 & 6 of the
#   handout). automationexercise.com is a real storefront with both a UI and
#   an API on the same backend, so a user created through the createAccount
#   API endpoint can genuinely log in through the browser — this suite
#   proves it, and checks the UI shows the same account name the API was
#   given.
# ------------------------------------------------------------------------------


*** Settings ***
Documentation         Creates an account via the automationexercise.com API,
...                    then logs in with that exact account through the
...                    browser and confirms the storefront recognizes it.
Library                SeleniumLibrary
Resource               ../../resources/automation_exercise_api.resource
Resource               ../../resources/automation_exercise_locators.resource
Suite Setup            Open Browser    about:blank    ${BROWSER}
Suite Teardown         Close All Browsers


*** Variables ***
# "chrome" opens a visible browser window. Override with
# "--variable BROWSER:headlesschrome" for CI or headless runs.
${BROWSER}    chrome


*** Test Cases ***
Account Created Via API Can Log In Through The UI
    [Documentation]
    ...    Registers a brand-new account through the createAccount API
    ...    (see [Setup]), then logs in through the real login page with
    ...    those exact credentials and confirms the header shows the same
    ...    account name the API was given — i.e. the UI actually matches
    ...    the backend, not just "some login succeeded".
    [Tags]    combined    positive
    [Setup]    Create Test User Via API
    [Teardown]    Delete Test User Via API
    Go To    ${LOGIN_URL}
    Wait Until Element Is Visible    ${LOGIN_EMAIL_FIELD}    timeout=10s
    Input Text        ${LOGIN_EMAIL_FIELD}       ${TEST_USER_EMAIL}
    Input Password    ${LOGIN_PASSWORD_FIELD}    ${TEST_USER_PASSWORD}
    Click Button       ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${LOGGED_IN_AS_INDICATOR}    timeout=10s
    Element Should Contain    ${LOGGED_IN_AS_INDICATOR}    ${TEST_USER_NAME}
