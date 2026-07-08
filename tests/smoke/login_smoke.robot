*** Comments ***
# ------------------------------------------------------------------------------
# login_smoke.robot
#
# What this file is for:
#   The SMOKE suite — a small, fast set of checks confirming the login
#   feature isn't completely broken. Meant to run on every commit/push,
#   before the fuller regression suite runs.
#
#   Rule of thumb used here: 1 positive case (a valid login must work) and
#   1 negative case (a clearly-invalid login must be rejected). That's
#   normally enough for a smoke check — deeper coverage belongs in
#   tests/regression/login_regression.robot instead.
# ------------------------------------------------------------------------------


*** Settings ***
Documentation       Smoke checks for the SauceDemo login page: confirms the
...                  core login flow works before running the full regression
...                  suite.
Library              SeleniumLibrary
Resource             ../../resources/login_keywords.resource
Suite Setup          Open Login Page
Suite Teardown       Close All Browsers
Test Setup           Reset To Login Page


*** Variables ***
# "chrome" opens a visible browser window. Override with
# "--variable BROWSER:headlesschrome" for CI or headless runs.
${BROWSER}    chrome


*** Test Cases ***
Standard User Can Log In
    [Documentation]    Positive case: a normal, working account must be able
    ...                to log in and reach the Products page.
    [Tags]    smoke    positive
    Login Should Succeed    standard_user    secret_sauce

Locked Out User Cannot Log In
    [Documentation]    Negative case: a locked-out account must be blocked,
    ...                with a clear error message shown to the user.
    [Tags]    smoke    negative
    Login Should Fail With Message
    ...    locked_out_user    secret_sauce
    ...    Epic sadface: Sorry, this user has been locked out.
