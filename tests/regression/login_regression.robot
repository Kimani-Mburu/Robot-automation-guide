*** Comments ***
# ------------------------------------------------------------------------------
# login_regression.robot
#
# What this file is for:
#   The REGRESSION suite — the fuller set of login scenarios: multiple valid
#   accounts, invalid credentials, and edge cases like empty fields. Meant to
#   run before a release, not necessarily on every single commit.
#
#   Includes one data-driven test at the end that reads accounts straight
#   from data/test_users.csv, using resources/CsvLibrary.py, so new test
#   accounts can be added by editing the CSV — no .robot changes needed.
# ------------------------------------------------------------------------------


*** Settings ***
Documentation        Regression checks for the SauceDemo login page: multiple
...                   valid accounts, invalid credentials, and edge cases.
Library               SeleniumLibrary
Library               ../../resources/CsvLibrary.py
Resource              ../../resources/login_keywords.resource
Suite Setup           Open Login Page
Suite Teardown        Close All Browsers
Test Setup            Reset To Login Page


*** Variables ***
# "chrome" opens a visible browser window. Override with
# "--variable BROWSER:headlesschrome" for CI or headless runs.
${BROWSER}    chrome


*** Test Cases ***
Standard User Can Log In
    [Documentation]    Baseline positive case, repeated here so the
    ...                regression suite can run completely on its own.
    [Tags]    regression    positive
    Login Should Succeed    standard_user    secret_sauce

Standard User Can Log Out
    [Documentation]    After logging in, using the burger menu's Logout
    ...                link must return the user to the login page.
    [Tags]    regression    positive
    Login Should Succeed    standard_user    secret_sauce
    Logout Should Return To Login Page

Problem User Can Still Log In
    [Documentation]    This account has known UI bugs elsewhere in the app,
    ...                but login itself must still work.
    [Tags]    regression    positive
    Login Should Succeed    problem_user    secret_sauce

Performance Glitch User Can Still Log In
    [Documentation]    This account responds slowly, but should still
    ...                authenticate successfully — just verifies it isn't
    ...                broken, not how fast it is.
    [Tags]    regression    positive
    Login Should Succeed    performance_glitch_user    secret_sauce

Locked Out User Is Blocked
    [Documentation]    A locked-out account must never be allowed to log in.
    [Tags]    regression    negative
    Login Should Fail With Message
    ...    locked_out_user    secret_sauce
    ...    Epic sadface: Sorry, this user has been locked out.

Login Fails With Wrong Password
    [Documentation]    A valid username with an incorrect password must be
    ...                rejected with the standard "do not match" message.
    [Tags]    regression    negative
    Login Should Fail With Message
    ...    standard_user    wrong_password
    ...    Epic sadface: Username and password do not match any user in this service

Login Fails With Unknown Username
    [Documentation]    A username that doesn't exist at all must be rejected,
    ...                using the same message as a wrong password (the app
    ...                deliberately doesn't reveal which field was wrong).
    [Tags]    regression    negative
    Login Should Fail With Message
    ...    not_a_real_user    secret_sauce
    ...    Epic sadface: Username and password do not match any user in this service

Login Fails With Empty Username
    [Documentation]    Edge case: submitting with no username must show a
    ...                validation message, not a generic error or a crash.
    [Tags]    regression    negative    edge
    Login Should Fail With Message
    ...    ${EMPTY}    secret_sauce
    ...    Epic sadface: Username is required

Login Fails With Empty Password
    [Documentation]    Edge case: submitting with no password must show a
    ...                validation message.
    [Tags]    regression    negative    edge
    Login Should Fail With Message
    ...    standard_user    ${EMPTY}
    ...    Epic sadface: Password is required

Login Fails With Both Fields Empty
    [Documentation]    Edge case: a completely blank form must show the
    ...                username validation message first.
    [Tags]    regression    negative    edge
    Login Should Fail With Message
    ...    ${EMPTY}    ${EMPTY}
    ...    Epic sadface: Username is required

Data Driven Check Of All Accounts In CSV
    [Documentation]    Reads every row from data/test_users.csv and checks
    ...                each account behaves the way its "expected_result"
    ...                column says it should. Add a new account to test by
    ...                adding a row to the CSV — no .robot changes required.
    [Tags]    regression    data-driven
    @{users}=    Read Csv As Dicts    ${CURDIR}/../../data/test_users.csv
    FOR    ${user}    IN    @{users}
        Reset To Login Page
        Run Keyword If    '${user}[expected_result]' == 'success'
        ...    Login Should Succeed    ${user}[username]    ${user}[password]
        ...    ELSE
        ...    Login Should Fail With Message
        ...        ${user}[username]    ${user}[password]
        ...        Epic sadface: Sorry, this user has been locked out.
    END
