*** Comments ***
# ------------------------------------------------------------------------------
# api_keywords.resource
#
# What this file is for:
#   The basic GET/POST/PUT/DELETE pattern from Section 3 of the handout,
#   wrapped into reusable keywords against the JSONPlaceholder session opened
#   in api_config.resource. Test cases call these instead of repeating raw
#   "GET On Session" calls in every test.
#
#   Note: JSONPlaceholder simulates writes. POST/PUT/DELETE all return a
#   normal, successful response, but nothing is actually persisted server
#   side — a follow-up GET will not show your change. That's fine for
#   practicing the request/response/assertion pattern; it's just not a
#   real datastore.
# ------------------------------------------------------------------------------


*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    api_config.resource


*** Keywords ***
Get All Posts
    [Documentation]    GET /posts — every post JSONPlaceholder has (always
    ...                the same 100 rows).
    ${response}=    GET On Session    jsonplaceholder    /posts
    RETURN    ${response}

Get Post By Id
    [Documentation]    GET /posts/{id}. Returns whatever status code the API
    ...                sends back — callers check it, this keyword doesn't.
    [Arguments]    ${post_id}
    ${response}=    GET On Session    jsonplaceholder    /posts/${post_id}
    RETURN    ${response}

Create Post
    [Documentation]    POST /posts with a JSON body. JSONPlaceholder echoes
    ...                back a fake new id (101) but doesn't persist it.
    [Arguments]    ${title}    ${body}    ${userId}
    &{payload}=    Create Dictionary
    ...    title=${title}
    ...    body=${body}
    ...    userId=${userId}
    ${response}=    POST On Session    jsonplaceholder    /posts    json=${payload}
    RETURN    ${response}

Update Post
    [Documentation]    PUT /posts/{id} with a JSON body, replacing the post.
    [Arguments]    ${post_id}    ${title}    ${body}    ${userId}
    &{payload}=    Create Dictionary
    ...    id=${post_id}
    ...    title=${title}
    ...    body=${body}
    ...    userId=${userId}
    ${response}=    PUT On Session    jsonplaceholder    /posts/${post_id}    json=${payload}
    RETURN    ${response}

Delete Post
    [Documentation]    DELETE /posts/{id}.
    [Arguments]    ${post_id}
    ${response}=    DELETE On Session    jsonplaceholder    /posts/${post_id}
    RETURN    ${response}
