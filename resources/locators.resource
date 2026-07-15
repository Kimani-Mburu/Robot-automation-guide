*** Comments ***
# ------------------------------------------------------------------------------
# locators.resource
#
# What this file is for:
#   Every element locator used by the login tests lives here, and ONLY here.
#   If the site's HTML changes (e.g. a developer renames an element ID),
#   this is the single place to fix it — nobody has to go hunting through
#   every test case.
#
# How to read a locator:
#   "id:user-name" means "find the element whose id attribute is user-name".
#   "css:[data-test=\"error\"]" means "find the element matching this CSS
#   selector". IDs are the most reliable locator type — see the automation
#   starter guide, Section 3, Step 2, for why.
# ------------------------------------------------------------------------------


*** Variables ***
# The page we're testing.
${LOGIN_URL}               https://www.saucedemo.com/

# --- Login form elements ---
${USERNAME_FIELD}          id:user-name
${PASSWORD_FIELD}          id:password
${LOGIN_BUTTON}            id:login-button


# Shown when login fails (wrong password, locked out account, etc.)
${ERROR_MESSAGE}           css:[data-test="error"]

# Shown on the Products page after a successful login — used to confirm
# that login actually worked.
${INVENTORY_TITLE}         css:.title

# --- Elements used for logging back out between tests ---
${BURGER_MENU_BUTTON}      id:react-burger-menu-btn
${LOGOUT_LINK}             id:logout_sidebar_link

# --- Shopping cart ---
${BACKPACK_ADD_BUTTON}      id:add-to-cart-sauce-labs-backpack

${SHOPPING_CART}            id:shopping_cart_container
${CART_BADGE}               css:.shopping_cart_badge

${CHECKOUT_BUTTON}          id:checkout
${FIRST_NAME}              id:first-name
${LAST_NAME}               id:last-name
${POSTAL_CODE}             id:postal-code

${CONTINUE_BUTTON}         id:continue
${FINISH_BUTTON}           id:finish

${COMPLETE_HEADER}         css:.complete-header
