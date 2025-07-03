# 📖 Разработка на NetGalaxyUP
Документация на всички команди и действия при създаване на проекта от нулата.

## 📦 develop.md – История на разработката на NetGalaxyUP
🗓️ Дата: **2025-07-03**
🧑‍💻 Оператор: **Ilko Yordanov**
🏁 Начало на проекта: **Инициализация от нула**

## ✅ Стъпка 1: Създаване на структурата на проекта

Първата стъпка е създаване на основната структура на проекта на локалната машина:

### 📁 Команди за изпълнение:

```bash
sudo mkdir -p NetGalaxyUP/{backend,frontend,packages,languages,scripts}
cd NetGalaxyUP
sudo touch README.md
```

## 🗂️ Получената структура:
```text
NetGalaxyUP/
├── backend/       # За FastAPI бекенд
├── frontend/      # За React фронтенд
├── packages/      # За логически модули (напр. login, profile)
├── languages/     # За JSON файлове с преводи
├── scripts/       # Инсталационни и помощни скриптове
└── README.md      # Документация
```

---

## ✅ Стъпка 2: Инициализиране на FastAPI проект (backend)

```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install fastapi uvicorn
touch main.py
```

### 📄 Съдържание на `main.py`

```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/health")
def read_health():
    return {"status": "ok"}
```

---

### ▶️ Стартиране на тестов сървър (по избор)

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

---

### 🌐 Достъп до API

`http://<IP-АДРЕС>:8000/health`

