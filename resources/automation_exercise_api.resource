*** Comments ***
# ------------------------------------------------------------------------------
# automation_exercise_api.resource
#
# What this file is for:
#   Create Test User Via API / Delete Test User Via API — the exact
#   [Setup]/[Teardown] pair from Section 4 of the handout. Unlike
#   JSONPlaceholder, automationexercise.com's API is real: createAccount
#   genuinely registers an account, and a user created here can genuinely
#   log in through the browser afterwards. deleteAccount cleans it back up
#   so test runs don't leave throwaway accounts behind.
#
#   Endpoints used (see https://automationexercise.com/api_list):
#     API 11 - POST /api/createAccount
#     API 4  - DELETE /api/deleteAccount
#
#   Both keywords store the generated credentials with "Set Test Variable"
#   rather than returning them, so they can be used directly as [Setup] and
#   [Teardown] without any argument plumbing in the test case itself.
# ------------------------------------------------------------------------------


*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String


*** Variables ***
${AUTOMATION_EXERCISE_BASE_URL}    https://automationexercise.com


*** Keywords ***
Create Test User Via API
    [Documentation]
    ...    Registers a brand-new account through the real createAccount API
    ...    endpoint. Uses a random suffix in the email so repeated test runs
    ...    never collide with a previous run's account. Sets
    ...    ${TEST_USER_EMAIL}, ${TEST_USER_PASSWORD}, and ${TEST_USER_NAME}
    ...    as test variables for the test case (and Delete Test User Via
    ...    API) to use.
    Create Session    automation_exercise    ${AUTOMATION_EXERCISE_BASE_URL}
    ${suffix}=    Generate Random String    8    [LOWER][NUMBERS]
    Set Test Variable    ${TEST_USER_EMAIL}      robot.${suffix}@mailinator.com
    Set Test Variable    ${TEST_USER_PASSWORD}    Test@1234
    Set Test Variable    ${TEST_USER_NAME}        Robot Tester ${suffix}
    &{account}=    Create Dictionary
    ...    name=${TEST_USER_NAME}
    ...    email=${TEST_USER_EMAIL}
    ...    password=${TEST_USER_PASSWORD}
    ...    title=Mr
    ...    birth_date=1
    ...    birth_month=1
    ...    birth_year=1990
    ...    firstname=Robot
    ...    lastname=Tester
    ...    company=Jireh Automation
    ...    address1=1 Test Street
    ...    address2=${EMPTY}
    ...    country=Kenya
    ...    zipcode=00100
    ...    state=Nairobi
    ...    city=Nairobi
    ...    mobile_phone=0700000000
    ${response}=    POST On Session    automation_exercise    /api/createAccount    data=&{account}
    Should Be Equal As Integers    ${response.json()}[responseCode]    201

Delete Test User Via API
    [Documentation]
    ...    Deletes the account created by Create Test User Via API, using
    ...    the real deleteAccount API endpoint. Reads the credentials that
    ...    keyword stored as test variables — no arguments needed at the
    ...    call site, so this can be used directly as [Teardown].
    &{credentials}=    Create Dictionary
    ...    email=${TEST_USER_EMAIL}
    ...    password=${TEST_USER_PASSWORD}
    ${response}=    DELETE On Session    automation_exercise    /api/deleteAccount    data=&{credentials}
    Should Be Equal As Integers    ${response.json()}[responseCode]    200
