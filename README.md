# Blogicum

Блог о путешествиях: публикации, категории, географические метки, админка.
Учебный проект спринта «Django + базы данных» (Яндекс Практикум).

## Стек

- Python 3.12
- Django 3.2
- SQLite
- pytest, mixer (тесты Практикума)

## Структура

```text
django_sprint3/
├── blogicum/
│   ├── blog/            модели Post / Category / Location, админка, view-функции
│   ├── pages/           статические страницы «О проекте» и «Наши правила»
│   ├── static/          css и картинки
│   ├── templates/       HTML-шаблоны проекта
│   ├── blogicum/        настройки и корневые маршруты
│   └── manage.py
├── tests/               автотесты Практикума
├── db.json              фикстуры с демо-данными
├── pytest.ini           конфиг тестов
├── requirements.txt     зависимости
└── .flake8              конфиг линтера
```

## Быстрый запуск

Windows (PowerShell, из корня проекта):

```powershell
py -3.12 -m venv venv
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
pip install pytz
cd blogicum
python manage.py migrate
python manage.py loaddata ../db.json
python manage.py createsuperuser
python manage.py runserver
```

Linux / macOS / WSL:

```bash
python3.12 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
pip install pytz
cd blogicum
python manage.py migrate
python manage.py loaddata ../db.json
python manage.py createsuperuser
python manage.py runserver
```

Есть готовые скрипты: `./setup.ps1` (Windows) и `bash setup.sh` (Linux/macOS).

После запуска открыть:

- `http://127.0.0.1:8000/` — главная страница, 5 последних публикаций;
- `http://127.0.0.1:8000/category/<slug>/` — страница категории;
- `http://127.0.0.1:8000/posts/<id>/` — страница публикации;
- `http://127.0.0.1:8000/admin/` — админка (логин из `createsuperuser`).

## Запуск в VS Code

1. Открыть папку `django_sprint3/` (File → Open Folder), установить
   рекомендованные расширения (VS Code сам предложит).
2. `Ctrl+Shift+P` → **Python: Select Interpreter** → выбрать
   `venv/Scripts/python.exe` (Windows) или `venv/bin/python` (Linux/macOS).
3. `F5` → конфигурация **«Django: запуск сервера (F5)»** — сервер поднимется
   с отладчиком, точки останова в `views.py` и `models.py` работают.
4. Тесты: `F5` → «pytest: все тесты», либо вкладка **Testing** (колба слева).

> Важно про админку: `loaddata ../db.json` **уже** приносит 4 пользователей,
> среди них суперпользователь `admin` (пароль из фикстур неизвестен). Поэтому
> `python manage.py createsuperuser --username admin` выдаст
> `Error: That имя пользователя is already taken`. Варианты:
> ```bash
> python manage.py changepassword admin       # задать свой пароль
> # или завести нового:
> python manage.py createsuperuser --username root
> ```

## Версии Python и Django (проверено)

| Python | Django | Результат |
|---|---|---|
| 3.12.15 | 3.2.16 (из `requirements.txt`) | 82 passed |
| 3.12.15 | 5.1.1 | 82 passed |
| 3.13.5 | 5.1.1 | 82 passed |
| 3.13.5 | 3.2.16 | **не запускается**: `ModuleNotFoundError: No module named 'cgi'` |

Вывод: держись связки **Python 3.12 + Django 3.2.16** — она проходит и на
старых тестах спринта, и на актуальных. Если на машине только Python 3.13,
самый простой выход — поставить 3.12 рядом (Windows: `py -3.12`; macOS:
`brew install python@3.12`) или поставить Django 5.1.1 и взять актуальные
тесты из `github.com/yandex-praktikum/django-sprint3` — со старыми тестами из
`ap-django2` на Django 5 два теста падают по вине самих тестов
(`filter(author=author)` после `author.delete()` в Django 5 бросает
`ValueError`, в актуальной версии тестов это исправлено на
`filter(author__id=author.id)`).

## Тесты и линтер

Из корня проекта (venv активирован):

```bash
pytest              # 82 passed
flake8 blogicum/    # без замечаний
```

## Правила показа публикаций

Пост виден на сайте, только если одновременно:

- `pub_date` не позже текущего времени (дату можно поставить в будущем —
  получится отложенная публикация);
- у поста снят флаг `is_published == False`? нет: `is_published == True`;
- категория поста опубликована.

Снятие с публикации локации на доступность поста не влияет; вместо локации в
шаблоне выводится «Планета Земля».

## Примечание

`DEBUG = True` и тестовый `SECRET_KEY` — только для учебной сборки.
