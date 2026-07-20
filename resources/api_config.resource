*** Comments ***
# ------------------------------------------------------------------------------
# api_config.resource
#
# What this file is for:
#   The session config for JSONPlaceholder — the one place ${API_BASE_URL}
#   lives. Every keyword in api_keywords.resource calls into the session
#   opened here, so pointing this whole project at a different API is a
#   one-line change. See "Adapting this to Jireh's own API" in the README.
# ------------------------------------------------------------------------------


*** Settings ***
Library    RequestsLibrary


*** Variables ***
${API_BASE_URL}    https://jsonplaceholder.typicode.com


*** Keywords ***
Create JSONPlaceholder Session
    [Documentation]
    ...    Opens the HTTP session reused by every keyword in
    ...    api_keywords.resource. Intended to be called once, in Suite Setup.
    Create Session    jsonplaceholder    ${API_BASE_URL}
