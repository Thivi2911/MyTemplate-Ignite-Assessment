.PHONY: help env deps clean lint test coverage ui-test security quality \
	agent-setup agent-resetdb agent-smoke agent-test

VENV_PYTHON=env/bin/python
AGENT_TEST_FILES=$(shell git ls-files 'tests/*.py')

help:
	@echo "Available commands:"
	@echo "  make env         create a development environment"
	@echo "  make deps        install dependencies"
	@echo "  make clean       remove generated files"
	@echo "  make lint        run Ruff static analysis"
	@echo "  make test        run backend tests"
	@echo "  make coverage    run tests with coverage reports"
	@echo "  make ui-test     run Playwright UI tests"
	@echo "  make security    run Bandit security scan"
	@echo "  make quality     run tests, coverage, lint and security checks"
	@echo "  make agent-setup install dependencies for AI/code agents"
	@echo "  make agent-resetdb reset and seed local development database"
	@echo "  make agent-smoke run fast smoke tests"
	@echo "  make agent-test  run full test suite with coverage"

env:
	python3 -m venv env && \
	. env/bin/activate && \
	make deps

deps:
	python -m pip install --upgrade pip
	python -m pip install -r requirements.txt
	python -m pip install pytest pytest-cov playwright pytest-playwright ruff bandit
	python -m playwright install chromium

clean:
	find . -type d -name "__pycache__" -prune -exec rm -rf {} +
	rm -rf .pytest_cache coverage_report test-reports
	rm -f .coverage coverage.xml ruff-report.json bandit-report.json

lint:
	ruff check appname tests --output-format=json > ruff-report.json

test:
	pytest tests/ --ignore=tests/test_ui.py

coverage:
	mkdir -p test-reports
	pytest tests/ \
		--ignore=tests/test_ui.py \
		--cov=appname \
		--cov-report=term-missing \
		--cov-report=xml \
		--cov-report=html:coverage_report \
		--junitxml=test-reports/results.xml

ui-test:
	pytest tests/test_ui.py

security:
	bandit -r appname -f json -o bandit-report.json

quality: coverage lint security ui-test

agent-setup:
	python3 -m venv env
	$(VENV_PYTHON) -m pip install --upgrade pip
	$(VENV_PYTHON) -m pip install -r requirements.txt

agent-resetdb:
	@if [ ! -x "$(VENV_PYTHON)" ]; then echo "Run 'make agent-setup' first."; exit 1; fi
	APPNAME_ENV=dev $(VENV_PYTHON) manage.py resetdb

agent-smoke:
	@if [ ! -x "$(VENV_PYTHON)" ]; then echo "Run 'make agent-setup' first."; exit 1; fi
	APPNAME_ENV=test $(VENV_PYTHON) -m pytest -q tests/test_urls.py tests/test_login.py

agent-test:
	@if [ ! -x "$(VENV_PYTHON)" ]; then echo "Run 'make agent-setup' first."; exit 1; fi
	APPNAME_ENV=test $(VENV_PYTHON) -m pytest \
		--cov-report=term-missing \
		--cov=appname \
		$(AGENT_TEST_FILES)