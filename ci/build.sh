#!/bin/sh
set -eu
mkdir -p artifacts
python3 -m venv .venv-ci
.venv-ci/bin/python -m pip install --disable-pip-version-check -r requirements.txt
.venv-ci/bin/python -m py_compile app.py
.venv-ci/bin/python app.py --check > artifacts/check-results.txt
cat artifacts/check-results.txt
{
  printf 'Commit: '
  git rev-parse HEAD
  printf 'Built at UTC: '
  date -u '+%Y-%m-%dT%H:%M:%SZ'
  .venv-ci/bin/python --version
  printf 'Build result: SUCCESS\n'
} > artifacts/build-metadata.txt
cat artifacts/build-metadata.txt
