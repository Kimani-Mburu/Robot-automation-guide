*** Comments ***
# ------------------------------------------------------------------------------
# automation_exercise_locators.resource
#
# What this file is for:
#   Every element locator used by the combined UI+API test lives here, and
#   ONLY here — same rule as the SauceDemo project's locators.resource.
# ------------------------------------------------------------------------------


*** Variables ***
${LOGIN_URL}                  https://automationexercise.com/login

# --- Login form (left-hand panel; the page also has a signup form) ---
${LOGIN_EMAIL_FIELD}          css:input[data-qa="login-email"]
${LOGIN_PASSWORD_FIELD}       css:input[data-qa="login-password"]
${LOGIN_BUTTON}                css:button[data-qa="login-button"]

# Shown when login fails (wrong password, unknown email, etc.)
${LOGIN_ERROR_MESSAGE}        xpath://form[@action="/login"]//p

# Shown in the site header after a successful login — includes the account's
# name, which is what lets us check the UI actually matches the account we
# just created through the API.
${LOGGED_IN_AS_INDICATOR}     xpath://a[contains(., "Logged in as")]
