*** Comments ***
# ------------------------------------------------------------------------------
# login_keywords.resource
#
# What this file is for:
#   Reusable, plain-English actions for the login flow. Test cases call these
#   keywords instead of repeating raw clicks/typing in every single test —
#   see the automation starter guide, Section 4, "Build Reusable Keywords".
#
# Every keyword below has a [Documentation] line explaining what it does,
# what arguments it needs, and what it checks.
# ------------------------------------------------------------------------------


*** Settings ***
Library     SeleniumLibrary
Resource    locators.resource


*** Keywords ***
Open Login Page
    [Documentation]
    ...    Opens a fresh browser and navigates to the SauceDemo login page.
    ...    Intended to be called once, in Suite Setup, so the same browser
    ...    window is reused across every test in the suite.
    ...
    ...    Chrome's built-in password manager flags "secret_sauce" as a
    ...    breached password and pops up a native "Change your password"
    ...    dialog after the first login. That dialog sits outside the page
    ...    DOM, steals focus, and silently blocks every click in later
    ...    tests — so the password manager and its leak detection are
    ...    disabled here.
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    ...    options=add_experimental_option("prefs", {"credentials_enable_service": False, "profile.password_manager_leak_detection": False})
    Maximize Browser Window
    Wait Until Element Is Visible    ${USERNAME_FIELD}    timeout=10s

Login As
    [Documentation]
    ...    Fills in the username and password fields and clicks Login.
    ...    Does NOT check the result — use "Login Should Succeed" or
    ...    "Login Should Fail With Message" instead, unless you specifically
    ...    need the raw action on its own.
    [Arguments]    ${username}    ${password}
    Input Text          ${USERNAME_FIELD}    ${username}
    Input Password      ${PASSWORD_FIELD}    ${password}
    Click Button         ${LOGIN_BUTTON}

Login Should Succeed
    [Documentation]
    ...    Logs in with the given credentials and verifies the login worked
    ...    by confirming the Products page title is visible.
    ...    Use this for POSITIVE test cases (valid accounts).
    [Arguments]    ${username}    ${password}
    Login As    ${username}    ${password}
    Wait Until Element Is Visible    ${INVENTORY_TITLE}    timeout=10s
    Element Text Should Be    ${INVENTORY_TITLE}    Products

Login Should Fail With Message
    [Documentation]
    ...    Attempts to log in with the given credentials and verifies login
    ...    was rejected, showing the expected error message.
    ...    Use this for NEGATIVE test cases (wrong password, locked out
    ...    account, empty fields, etc.).
    [Arguments]    ${username}    ${password}    ${expected_message}
    Login As    ${username}    ${password}
    Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=10s
    Element Text Should Be    ${ERROR_MESSAGE}    ${expected_message}

Logout
    [Documentation]
    ...    Logs the current user out via the burger menu. Only works if a
    ...    user is currently logged in. Does NOT check the result — use
    ...    "Logout Should Return To Login Page" instead unless you
    ...    specifically need the raw action on its own.
    Click Element    ${BURGER_MENU_BUTTON}
    Wait Until Element Is Visible    ${LOGOUT_LINK}    timeout=5s
    Click Element    ${LOGOUT_LINK}

Logout Should Return To Login Page
    [Documentation]
    ...    Logs out via the burger menu and verifies it actually worked by
    ...    confirming the login form is visible again.
    ...    Use this for verifying LOGOUT itself, not just performing it.
    Logout
    Wait Until Element Is Visible    ${USERNAME_FIELD}    timeout=10s

Reset To Login Page
    [Documentation]
    ...    Clears any logged-in session (cookies + local/session storage)
    ...    and returns to the login page.
    ...
    ...    Why this exists: SauceDemo remembers a logged-in user through
    ...    browser local storage. Just navigating back to the login URL
    ...    between tests is NOT enough — it can silently redirect straight
    ...    back to the Products page. Call this at the start of every test
    ...    (see Test Setup in the .robot files) so each test genuinely
    ...    starts from a logged-out state.
    Go To    ${LOGIN_URL}
    Delete All Cookies
    Execute Javascript    window.localStorage.clear();
    Execute Javascript    window.sessionStorage.clear();
    Go To    ${LOGIN_URL}
    Wait Until Element Is Visible    ${USERNAME_FIELD}    timeout=10s
