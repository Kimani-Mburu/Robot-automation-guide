# Robot Automation Guide

Robot Framework automation built as a class practice project, covering UI
testing on [saucedemo.com](https://www.saucedemo.com/) (Classes 4–5) and API
testing with RequestsLibrary (Class 6). Structure follows the "Robot
Framework: Automating a Real Codebase" starter guide.

## Project Layout

```
.
├── tests/
│   ├── smoke/
│   │   └── login_smoke.robot                # UI: fast checks, 1 positive + 1 negative
│   ├── regression/
│   │   ├── login_regression.robot            # UI: fuller login suite, edge cases, data-driven
│   │   └── check_out.robot                    # UI: checkout flow regression
│   ├── api/
│   │   └── posts_api_tests.robot              # pure API suite against JSONPlaceholder
│   └── combined/
│       └── ui_api_combined_tests.robot         # create user via API, log in via UI
├── resources/
│   ├── locators.resource                      # SauceDemo element locators
│   ├── login_keywords.resource                # reusable SauceDemo login/logout keywords
│   ├── check_out_keywords.resource             # reusable SauceDemo checkout keywords
│   ├── CsvLibrary.py                           # small Python helper to read CSV test data
│   ├── api_config.resource                     # JSONPlaceholder session config
│   ├── api_keywords.resource                    # reusable JSONPlaceholder GET/POST/PUT/DELETE keywords
│   ├── automation_exercise_api.resource         # real createAccount/deleteAccount API calls
│   └── automation_exercise_locators.resource    # automationexercise.com login page locators
├── data/
│   └── test_users.csv                 # SauceDemo's standard test accounts
├── results/                           # generated when you run tests — not committed
├── .venv/                             # your virtual environment — not committed
└── requirements.txt
```

Every `.resource`, `.robot`, and `.py` file starts with a comment block
explaining what it's for, and every keyword/test case has a
`[Documentation]` line explaining what it does and why.

## API Test Targets

The API suites hit two different demo sites, on purpose:

| Suite | Site | Why |
|---|---|---|
| `tests/api/` | [jsonplaceholder.typicode.com](https://jsonplaceholder.typicode.com) | Free, no signup, no API key. Good for raw GET/POST/PUT/DELETE and JSON assertions. Writes are simulated (not persisted), so there's no matching UI to log into. |
| `tests/combined/` | [automationexercise.com](https://automationexercise.com) | A real storefront with both a UI and an API on the same backend — a user created through `createAccount` can genuinely log in through the browser afterwards. |

## Prerequisites

Before you start, make sure you have:

- **Python 3.9+** — check with `python3 --version`
- **Google Chrome** installed — check with `google-chrome --version`

You don't need to install a browser driver by hand — Selenium Manager
(bundled with Selenium 4.6+) downloads the matching chromedriver
automatically the first time you run the tests.

## Test Accounts Used

All SauceDemo accounts share the password `secret_sauce`:

| Username                 | Expected Result | Notes                            |
|---------------------------|-----------------|------------------------------------|
| standard_user              | Success         | Normal working account            |
| locked_out_user            | Fail            | Account has been locked out       |
| problem_user                | Success         | Logs in but has UI bugs           |
| performance_glitch_user     | Success         | Logs in but responds slowly       |

These live in `data/test_users.csv` and are used both by the individual
test cases and by the data-driven test at the end of the regression suite.

## Setup

This project uses a **virtual environment** (a self-contained folder for
Python packages) so the libraries it needs don't clash with anything else
on your machine. You only need to create it once.

**1. Create the virtual environment** (run this from the project root,
the folder this README is in):
```bash
python3 -m venv .venv
```
This creates a `.venv/` folder holding a private copy of Python and pip.
It's already excluded from git via `.gitignore`, so it never gets committed.

**2. Activate it.** You'll need to do this every time you open a new
terminal to work on this project:

macOS / Linux:
```bash
source .venv/bin/activate
```

Windows (Command Prompt):
```bat
.venv\Scripts\activate.bat
```

Windows (PowerShell):
```powershell
.venv\Scripts\Activate.ps1
```

Your terminal prompt should now start with `(.venv)` — that confirms it's
active.

**3. Install the project's dependencies into the virtual environment:**
```bash
pip install -r requirements.txt
```

That installs Robot Framework, SeleniumLibrary, and RequestsLibrary. You
only need to redo this step if `requirements.txt` changes.

> **Tip:** If you'd rather not activate the environment every time, you
> can call the tools inside `.venv` directly, e.g. `.venv/bin/robot ...`
> and `.venv/bin/pip ...` (or `.venv\Scripts\robot.exe` on Windows). The
> commands below assume you've activated it, so `robot` on its own is enough.

## Running the Tests

Run everything:
```bash
robot --outputdir results tests/
```

Run just the smoke suite:
```bash
robot --outputdir results/smoke tests/smoke/
```

Run just the regression suite:
```bash
robot --outputdir results/regression tests/regression/
```

Run the pure API suite (no browser needed):
```bash
robot --outputdir results/api tests/api/
```

Run the combined UI + API suite (creates a real account via API, then logs
in with it through the browser — needs Chrome/Chromium installed):
```bash
robot --outputdir results/combined tests/combined/
```

Run only tests tagged "negative":
```bash
robot --include negative --outputdir results tests/
```

After running, open `results/report.html` or `results/log.html` in a
browser to see pass/fail results and step-by-step details.

### Watching the browser vs. running headless

By default, both suites open a real, visible Chrome window (`${BROWSER}`
is set to `chrome`) so you can watch each test click through the login
form. To run without a visible window instead — faster, and what CI
should use — override the variable from the command line:

```bash
robot --variable BROWSER:headlesschrome --outputdir results tests/
```

## Troubleshooting

**A "Change your password" popup interrupts the tests.** Chrome's
built-in password manager flags `secret_sauce` as a breached password
and shows a native dialog after the first login. This is already handled
in `Open Login Page` (in `resources/login_keywords.resource`), which
disables Chrome's password manager and leak detection when the browser
opens. If you still see it, make sure you're running the tests as they
are in this repo rather than a modified copy of `Open Browser`.

**Chrome doesn't seem to open, or nothing visible happens.** Confirm
`${BROWSER}` is set to `chrome` (not `headlesschrome`) in the suite's
`*** Variables ***` section, or that you didn't pass
`--variable BROWSER:headlesschrome` on the command line.

**`robot: command not found`.** Your virtual environment isn't active —
re-run the activate command from step 2 of Setup, or call
`.venv/bin/robot` directly.

## What's Covered

**Smoke suite** — 2 tests: standard user logs in successfully; locked-out
user is blocked.

**Regression suite** — 11 tests: standard/problem/performance-glitch users
all log in successfully; standard user can log back out via the burger
menu; locked-out user is blocked; wrong password and unknown username are
rejected; empty username, empty password, and both empty are rejected with
the correct validation message; and one data-driven test that reads every
account from `data/test_users.csv`.

**API suite** — 6 tests against JSONPlaceholder's `/posts` endpoint:
listing, fetching by id, creating, updating, deleting, and a deliberate
negative test (`Get Post With Invalid Id Returns 404`).

**Combined suite** — 1 test: registers a real account via the
automationexercise.com API, logs in through the browser with those exact
credentials, and confirms the header shows the same account name — proving
the UI and API genuinely share a backend.

## Running in CI

`.github/workflows/tests.yml` runs four jobs. `smoke`, `api`, and `combined`
run on every push/PR to `main`/`develop`. `regression` only runs on the
nightly schedule (`workflow_dispatch` also triggers it manually) — it's the
slower, fuller suite, so it isn't run on every commit. All browser-based
jobs pass `--variable BROWSER:headlesschrome`, since CI runners don't have
a display to show a real Chrome window.

## A Note on Session State

SauceDemo keeps a user "logged in" via browser local storage, so simply
navigating back to the login URL between tests isn't enough — it can
silently redirect straight to the inventory page. The `Reset To Login Page`
keyword in `login_keywords.resource` clears cookies and local/session
storage before every test, so each test starts from a genuinely logged-out
state. This is called automatically via `Test Setup` in both suites.
