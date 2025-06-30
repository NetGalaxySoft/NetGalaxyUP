# 🌌 NetGalaxyUP 
### Потребителски профили за мрежата на бъдещето.

**NetGalaxyUP** (*NetGalaxy User Profile*) е уеб базирана система за управление на потребителски профили, създадена като част от екосистемата на проекта [NetGalaxy](https://netgalaxy.org).

Този репозиторий съдържа скелета и основните модули на приложението: backend (FastAPI), frontend (React+Vite) и езикова поддръжка.

---

## 🧱 Основни компоненти

- ⚙️ **Backend**: Python 3.10+, FastAPI, SQLAlchemy, Alembic  
- 🎨 **Frontend**: React, Vite, CSS Grid  
- 🌐 **API маршрут**: `/health` (проверка за работа)  
- 🌍 **Многоезичност**: Структура за `bg` и `en`  

---

## 📂 Структура на проекта

NetGalaxyUP/
├── backend/ # FastAPI backend
├── frontend/ # React frontend
├── packages/ # Логически модули (login, profile, settings)
├── modules/ # Бъдещи микросървъри/функции
├── languages/ # JSON файлове с преводи
└── README.md # Този файл

---

## ⚙️ Локално стартиране

### 🔧 Изисквания:
- Python 3.10+  
- Node.js 16+  
- npm 8+  
- Git

### 🐍 Стартиране на бекенд:
```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn src.app:app --reload
```

### 🧑‍🎨 Стартиране на фронтенд:
```bash
cd frontend
npm install
npm run dev
```

📡 **Бекенд:**  
http://localhost:8000

🎨 **Фронтенд:**  
http://localhost:5173

---

### 🚀 Какво предстои

- 🔐 Модул за вход (Login)  
- 👤 Модул за потребителски профил  
- ⚙️ Настройки и избор на език  
- 📱 Поддръжка за мобилни устройства  
- 🌐 Хостване и разгръщане в облак  
- 🧪 Автоматични тестове и CI/CD

---

### 🛡️ Лиценз

Този проект е публикуван под лиценза **MIT**.  
Свободен е за използване, модификация и разпространение при условията на този лиценз.

---

### 🤝 Принос и сътрудничество

Проектът е отворен за сътрудничество.  
Ако имате идеи, предлагате подобрения или откриете проблем – можеш да подадете сигнал на:

- [Issue](https://github.com/NetGalaxySoft/NetGalaxyUP/issues)  
- [Pull request](https://github.com/NetGalaxySoft/NetGalaxyUP/pulls)

