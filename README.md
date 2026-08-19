# MyTemplate

A Flask app based on the Ignite starter project, renamed to MyTemplate as part of a DevOps/QA assessment. Along with the rename, this repo includes a small quality pipeline: automated tests, UI tests, linting, security scanning, and report generation, all wired up through a Makefile and a GitHub Actions workflow.

## What's in here

- Renamed the app from Ignite to MyTemplate
- Existing backend test suite (pytest), verified to still pass after the rename
- A new UI test (Playwright) that checks the homepage shows the MyTemplate branding
- Coverage reporting with pytest-cov
- Static analysis with Ruff
- Security scanning with Bandit
- A Makefile so all of the above can be run with one command
- A GitHub Actions workflow that runs the same checks on every push/PR

## Getting set up

```bash
python -m venv venv
```

Activate it:

```bash
# macOS/Linux
source venv/bin/activate

# Windows
venv\Scripts\activate
```

Install everything:

```bash
pip install -r requirements.txt
pip install pytest pytest-cov playwright pytest-playwright ruff bandit
python -m playwright install chromium
```

## Running the app

```bash
python manage.py server
```

It'll be running at `http://127.0.0.1:5000`.

## Running the checks

Everything's wired up in the Makefile:

```bash
make test        # backend tests
make ui-test      # Playwright UI test (needs the app running)
make coverage     # backend tests + coverage report
make lint         # Ruff
make security     # Bandit
make quality      # runs all of the above
```

Reports land here after a run:

| Report | Location |
|---|---|
| Test results | `test-reports/results.xml` |
| Coverage (HTML) | `coverage_report/` |
| Coverage (XML) | `coverage.xml` |
| Ruff | `ruff-report.json` |
| Bandit | `bandit-report.json` |

## CI

The same checks run automatically on push and pull request via `.github/workflows/flask-pytest.yml`. Reports are uploaded as a downloadable artifact on each run.

## Project structure

```
MyTemplate-Ignite-Assessment/
├── appname/
├── tests/
│   └── test_ui.py
├── .github/
│   └── workflows/
│       └── flask-pytest.yml
├── Makefile
├── requirements.txt
├── manage.py
└── README.md
```