# Windows PowerShell. Запускать из корня проекта (там, где лежит pytest.ini).
$ErrorActionPreference = "Stop"

# Django 3.2 работает на Python 3.10-3.12; на 3.13 он не ставится/не стартует.
# Список установленных версий:  py -0
$found = $false
foreach ($v in @("3.12", "3.11", "3.10")) {
    py -$v -c "print()" 2>$null
    if ($LASTEXITCODE -eq 0) { $found = $v; break }
}
if (-not $found) {
    Write-Host "Нужен Python 3.10-3.12. Скачать: https://www.python.org/downloads/release/python-31210/" -ForegroundColor Red
    exit 1
}
Write-Host "Использую Python $found"

py -$found -m venv venv
.\venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r requirements.txt

Set-Location blogicum
python manage.py migrate
python manage.py loaddata ../db.json
python manage.py createsuperuser
Write-Host "Теперь: python manage.py runserver  ->  http://127.0.0.1:8000/" -ForegroundColor Green
Write-Host "Тесты (из корня проекта): pytest" -ForegroundColor Green
