*** Comments ***
# ------------------------------------------------------------------------------
# posts_api_tests.robot
#
# What this file is for:
#   The pure API suite (Sections 3 & 5 of the handout) — raw GET/POST/PUT/
#   DELETE against JSONPlaceholder's /posts endpoint and JSON assertions on
#   the responses. No browser involved.
#
#   Includes one deliberate negative test (Get Post With Invalid Id Returns
#   404) — always test the failure case, not just the happy path.
# ------------------------------------------------------------------------------


*** Settings ***
Documentation         Pure API checks against JSONPlaceholder's /posts
...                    endpoint: reading, creating, updating, and deleting
...                    posts, plus a not-found check.
Library                RequestsLibrary
Resource               ../../resources/api_config.resource
Resource               ../../resources/api_keywords.resource
Suite Setup            Create JSONPlaceholder Session


*** Test Cases ***
Get All Posts Returns A List Of 100
    [Documentation]    JSONPlaceholder always has exactly 100 seeded posts.
    [Tags]    api    positive
    ${response}=    Get All Posts
    Status Should Be    200    ${response}
    Length Should Be    ${response.json()}    100

Get Post By Id Returns The Matching Post
    [Documentation]    Fetching post 1 must return post 1, not just "a" post.
    [Tags]    api    positive
    ${response}=    Get Post By Id    1
    Status Should Be    200    ${response}
    Should Be Equal As Integers    ${response.json()}[id]    1

Get Post With Invalid Id Returns 404
    [Documentation]    Deliberate negative test: an id that doesn't exist
    ...                must come back as 404, not a silent empty success.
    [Tags]    api    negative
    ${response}=    Get Post By Id    99999
    Status Should Be    404    ${response}

Create Post Returns The Created Resource
    [Documentation]    POST must echo back the fields we sent, plus a new id.
    [Tags]    api    positive
    ${response}=    Create Post    My Test Title    My Test Body    userId=1
    Status Should Be    201    ${response}
    Should Be Equal As Strings    ${response.json()}[title]    My Test Title

Update Post Changes The Title
    [Documentation]    PUT must return the post with the new title applied.
    [Tags]    api    positive
    ${response}=    Update Post    1    Updated Title    Updated Body    userId=1
    Status Should Be    200    ${response}
    Should Be Equal As Strings    ${response.json()}[title]    Updated Title

Delete Post Succeeds
    [Documentation]    DELETE must return 200 for an existing post id.
    [Tags]    api    positive
    ${response}=    Delete Post    1
    Status Should Be    200    ${response}
