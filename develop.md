# 📖 Разработка на NetGalaxyUP  
## Документация на всички команди и действия при създаване на проекта от нулата

---

## 📦 develop.md – История на разработката на NetGalaxyUP  
- 🗓️ Дата на създаване: **2025-07-03**  
- 🧑‍💻 Автор: **Ilko Yordanov / NetGalaxySoft**  
- 🏁 Статус: **Инициализация от нула**  
- 🧾 Версия на документа: **v0.1 (етап на създаване)**  

---

### ✅ Създаване и конфигуриране на групата `netgalaxyup`

```bash
# Създаване на нова група с името на проекта
sudo groupadd netgalaxyup

# Добавяне на текущия потребител към групата
sudo usermod -aG netgalaxyup $USER
```

🔁 **Излезте от сесията и влезте отново в интерфейса на сървъра, за да влязат в сила промените в груповите права.**

---

## ✅ Стъпка 1: Създаване структурата на проекта  
  
### 🗂️ Основна структура на приложението:
```
NetGalaxyUP/
├── backend/                   # FastAPI сървър (API бекенд)
│   ├── main.py                # Начален API файл
│   ├── templates/             # HTML шаблони за FastAPI
│   └── venv/                  # Виртуална среда за backend
├── frontend/                  # Клиентска част (PWA интерфейс)
│   ├── src/                   # Изходен код на интерфейса (React + Vite)
│   │   └── components/        # Компоненти на интерфейса
│   │       ├── layout/        # Основни елементи: TopBar, SideBar, Footer
│   │       ├── workspace/     # Централна зона за съдържание (Workspace)
│   │       └── shared/        # Общи елементи: известия и др.
│   └── public/                # Статични ресурси (favicon, manifest и др.)
├── languages/                 # JSON файлове с езикови преводи
├── packages/                  # Основни пакети (напр. login, profile)
├── scripts/                   # Скриптове (напр. fastapi-autostart.sh)
└── README.md                  # Документация на проекта
```

### 📁 Команди за изпълнение:

```bash
# 1. Създаване на основните директории на проекта
mkdir -p NetGalaxyUP/{backend/templates,backend/venv,frontend/{src/components/{layout,shared,workspace},public},languages,packages,scripts}

# 2. Задаване на собственик: текущ потребител и група netgalaxyup
sudo chown -R $USER:netgalaxyup NetGalaxyUP

# 3. Достъп за четене и писане от членовете на групата
sudo chmod -R g+rwX NetGalaxyUP

# 4. Наследяване на групата при създаване на нови файлове
sudo chmod g+s NetGalaxyUP

# 5. Влизане в директорията на проекта и създаване на празен README файл за начална документация

cd NetGalaxyUP
touch README.md
```
  
### ✅ Коментари:
- Тази структура е съобразена с реалната архитектура на NetGalaxyUP и е подходяща за мобилно PWA приложение, базирано на FastAPI + Tailwind.  
  
- След създаване на структурата е необходимо да се зададат правилни права за достъп до проекта, така че всички участници в групата netgalaxyup да имат достъп без използване на sudo.

---

Разбрах! Ето преработената **Стъпка 2**, валидна за включване в `develop.md`, във **чист и правилен Markdown формат**, съобразен с последните промени в скрипта `fastapi-autostart.sh` (който вече използва параметър `-b` за backend):

---

## ✅ Стъпка 2: Инициализиране на FastAPI проект (backend)

```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install fastapi uvicorn
```

### ✅ 2.1. Създаване на началния файл `main.py`

```bash
touch main.py
nano main.py
```

Поставете в `main.py` следния код:

```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"status": "ok"}

@app.get("/health")
def read_health():
    return {"app": "NetGalaxyUP", "status": "ok"}
```

---

### ✅ 2.2. Изтегляне и стартиране на FastAPI сървъра (порт 8000)

```bash
cd ~/NetGalaxyUP
curl -fsSL https://NetGalaxySoft:<TOKEN>@raw.githubusercontent.com/NetGalaxySoft/servers/main/scripts/fastapi-autostart.sh -o scripts/fastapi-autostart.sh
chmod +x scripts/fastapi-autostart.sh
./scripts/fastapi-autostart.sh -b 8000
```

---

### 🌐 2.3. Тест на FastAPI сървъра

Проверете в браузър или чрез `curl` дали сървърът отговаря:

* `http://<IP_ADDRESS>:8000`
  трябва да върне:

  ```json
  {"status": "ok"}
  ```

* `http://<IP_ADDRESS>:8000/health`
  трябва да върне:

  ```json
  {"app": "NetGalaxyUP", "status": "ok"}
  ```

---

# ✅ Стъпка 3: Създаване на реален frontend с Vite + React + Tailwind (PWA структура)

> ⚠️ Тази стъпка използва стабилна, поддържана и професионална структура за мобилно PWA приложение.

---

## ✅ 3.1. Инициализация на проекта с Vite + React

```bash
cd ~/NetGalaxyUP/frontend
npm create vite@latest . -- --template react
```
🔹 На въпрос за име на проекта, натиснете `Enter`, тъй като вече сте в папката `frontend`.

🔹 Ако се появи следното съобщение:
```bash
◆  Current directory is not empty. Please choose how to proceed:
○ Cancel operation
○ Remove existing files and continue
● Ignore files and continue
```
✅ Изберете: Ignore files and continue

Това ще запази всички съществуващи папки (като src/components/) и ще добави само нужните файлове на Vite шаблона, без да изтрива нищо.

Завършете инсталацията с:
```bash
npm install
```

---

## ✅ 3.2. Инсталиране и конфигурация на Tailwind CSS

```bash
# 📤 Излизане от Python виртуална среда (ако е активна)
deactivate || true

# 📦 Инсталиране на съвместими и стабилни версии на Tailwind и свързаните зависимости
npm install -D tailwindcss@3.4.3 postcss@8.4.38 autoprefixer@10.4.19

# ⚙️ Създаване на конфигурационни файлове за Tailwind и PostCSS
npx tailwindcss init -p

```

---

## ✅ 3.3. Конфигурация на Tailwind (`tailwind.config.js`)

```bash
nano tailwind.config.js
```

Заменете съдържанието с:

```js
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
```

---

## ✅ 3.4. Конфигурация на Tailwind в `src/index.css`

```bash
nano src/index.css
```

Заменете съдържанието с:

```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

---

# ✅ Стъпка 4: Създаване на основните компоненти на интерфейса

🔹 Работна директория за тази стъпка:
```bash
cd ~/NetGalaxyUP/frontend
```

## ✅ 4.1. Създаване на `TopBar.jsx`

```bash
nano src/components/layout/TopBar.jsx
```

```jsx
export default function TopBar() {
  return (
    <header className="w-full h-16 bg-blue-300 flex items-center px-4 shadow">
      <span className="font-bold text-lg text-white">NetGalaxyUP</span>
    </header>
  );
}
```

---

## ✅ 4.2. Създаване на `SideBar.jsx`

```bash
nano src/components/layout/SideBar.jsx
```

```jsx
export default function SideBar() {
  return (
    <aside className="w-48 bg-green-300 h-full p-4">
      <p className="font-semibold text-white">Навигация</p>
    </aside>
  );
}
```

---

## ✅ 4.3. Създаване на `Workspace.jsx`

```bash
nano src/components/workspace/Workspace.jsx
```

```jsx
export default function Workspace() {
  return (
    <main className="flex-1 bg-gray-100 p-6">
      <p className="text-gray-800">Работно пространство</p>
    </main>
  );
}
```

---

## ✅ 4.4. Създаване на `Footer.jsx`

```bash
nano src/components/layout/Footer.jsx
```

```jsx
export default function Footer() {
  return (
    <footer className="w-full h-12 bg-red-300 flex items-center justify-center text-white">
      © 2025 NetGalaxyUP
    </footer>
  );
}
```

---

## ✅ 4.5. Импортиране и сглобяване в `App.jsx`

```bash
nano src/App.jsx
```

```jsx
import TopBar from "./components/layout/TopBar";
import SideBar from "./components/layout/SideBar";
import Workspace from "./components/workspace/Workspace";
import Footer from "./components/layout/Footer";

function App() {
  return (
    <div className="flex flex-col min-h-screen">
      <TopBar />
      <div className="flex flex-1">
        <SideBar />
        <Workspace />
      </div>
      <Footer />
    </div>
  );
}

export default App;
```

---

## ✅ 4.6. Стартиране и визуална проверка

```bash
# Създаване на systemd услуга за Vite сървъра на порт 5173
cd ~/NetGalaxyUP
./scripts/fastapi-autostart.sh -v 5173

```

Отворете в браузъра:  
`http://<IP_ADDRESS>:5173`

Трябва да виждаш:

* горна лента с надпис **NetGalaxyUP**
* зелена странична лента **Навигация**
* работна зона със съдържание
* долен червен футър

---

Готово! Това е **минимален, но функционален скелет** на приложението NetGalaxyUP, изграден по всички правила.

  
---

## 🧹 Сервизна операция: Пълно премахване на проекта

> Използвайте само ако желаете да изтриете **цялата инсталация на NetGalaxyUP** от сървъра.

```bash
# ⛔️ Спиране и премахване на бекенд FastAPI сървър
sudo systemctl stop netgalaxyup8000
sudo systemctl disable netgalaxyup8000
sudo rm /etc/systemd/system/netgalaxyup8000.service

# ⛔️ Спиране и премахване на фронтенд Vite сървър
sudo systemctl stop netgalaxyupv5173
sudo systemctl disable netgalaxyupv5173
sudo rm /etc/systemd/system/netgalaxyupv5173.service

# 🔄 Презареждане на systemd, за да премахне старите записи
sudo systemctl daemon-reload

# 🗑️ Изтриване на директорията на проекта
cd ~
sudo rm -rf NetGalaxyUP
```

---
