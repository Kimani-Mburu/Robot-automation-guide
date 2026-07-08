# SauceDemo Login Automation

Robot Framework automation for the login flow on [saucedemo.com](https://www.saucedemo.com/),
built as a class practice project. Structure follows the "Robot Framework:
Automating a Real Codebase" starter guide, Section 4.

## Project Layout

```
saucedemo_login_project/
├── tests/
│   ├── smoke/
│   │   └── login_smoke.robot          # fast checks: 1 positive, 1 negative
│   └── regression/
│       └── login_regression.robot     # fuller set: positive, negative, edge, data-driven
├── resources/
│   ├── locators.resource              # every element locator, in one place
│   ├── login_keywords.resource        # reusable keywords (Login As, Logout, etc.)
│   └── CsvLibrary.py                  # small Python helper to read CSV test data
├── data/
│   └── test_users.csv                 # SauceDemo's standard test accounts
├── results/                           # generated when you run tests — not committed
├── .venv/                             # your virtual environment — not committed
└── requirements.txt
```

Every `.resource`, `.robot`, and `.py` file starts with a comment block
explaining what it's for, and every keyword/test case has a
`[Documentation]` line explaining what it does and why.

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

That installs Robot Framework and SeleniumLibrary. You only need to redo
this step if `requirements.txt` changes.

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

## Running in CI

There's no CI workflow set up in this repo yet. If you add one (e.g. a
GitHub Actions workflow at `.github/workflows/tests.yml`), remember to run
the suites headless there — pass `--variable BROWSER:headlesschrome`, since
CI runners don't have a display to show a real Chrome window.

## A Note on Session State

SauceDemo keeps a user "logged in" via browser local storage, so simply
navigating back to the login URL between tests isn't enough — it can
silently redirect straight to the inventory page. The `Reset To Login Page`
keyword in `login_keywords.resource` clears cookies and local/session
storage before every test, so each test starts from a genuinely logged-out
state. This is called automatically via `Test Setup` in both suites.
