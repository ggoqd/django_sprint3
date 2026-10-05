#!/usr/bin/env bash
# macOS / Linux / WSL. Запускать из корня проекта (там, где лежит pytest.ini).
set -euo pipefail

# Django 3.2 работает на Python 3.10-3.12; на 3.13 он не стартует.
PY=""
for v in python3.12 python3.11 python3.10; do
  if command -v "$v" >/dev/null 2>&1; then PY="$v"; break; fi
done
if [ -z "$PY" ]; then
  echo "Нужен Python 3.10-3.12 (pyenv или brew install python@3.12)." >&2
  exit 1
fi
echo "Использую $PY ($($PY -V))"

"$PY" -m venv venv
# shellcheck disable=SC1091
source venv/bin/activate
python -m pip install --upgrade pip
pip install -r requirements.txt

cd blogicum
python manage.py migrate
python manage.py loaddata ../db.json
python manage.py createsuperuser
echo "Теперь: python manage.py runserver  ->  http://127.0.0.1:8000/"
echo "Тесты (из корня проекта): pytest"
