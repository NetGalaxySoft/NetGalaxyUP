# 📖 Разработка на NetGalaxyUP
Документация на всички команди и действия при създаване на проекта от нулата.

---

## 📦 develop.md – История на разработката на NetGalaxyUP
🗓️ Дата: **2025-07-03**
🧑‍💻 Оператор: **Ilko Yordanov**
🏁 Начало на проекта: **Инициализация от нула**

---

## 🧑‍💻 Конфигуриране на потребителска група за проекта NetGalaxyUP

### 📌 Защо е важно това?

Когато няколко разработчици работят по един и същи проект, е от съществено значение всички да имат достъп до файловете, без да се използва `sudo` или да се сменя собственик ръчно. Създаването на **специална група**, носеща името на проекта, позволява гъвкав и сигурен контрол върху правата за достъп до проекта.

Това избягва проблеми със собствеността на файловете и позволява ефективна съвместна работа в екип.

---

### ✅ Създаване и конфигуриране на групата `netgalaxyup`

```bash
# Създаване на нова група с името на проекта
sudo groupadd netgalaxyup

# Добавяне на текущия потребител към групата
sudo usermod -aG netgalaxyup $USER
```

🔁 **Излезте от сесията и влезте отново в интерфейса на сървъра, за да влязат в сила промените в груповите права.**

## ✅ Стъпка 1: Създаване на структурата на проекта

Първата стъпка е създаване на основната структура на проекта на локалната машина:

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

# 5. Влизане в директорията на проекта и създаване на README
cd NetGalaxyUP
touch README.md

```
### 🗂️ Получената структура:
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

### ✅ Коментар:
Тази структура е съобразена с реалната архитектура на NetGalaxyUP и е подходяща за мобилно PWA приложение, базирано на FastAPI + Tailwind.


### 🛡️ Настройка на права за съвместна разработка
След създаване на структурата е необходимо да се зададат правилни права за достъп до проекта, така че всички участници в групата netgalaxyup да имат достъп без използване на sudo.

---

## ✅ Стъпка 2: Инициализиране на FastAPI проект (backend)

```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install fastapi uvicorn
```

### 2.1. Създаване на началния файл на приложението:
```bash
touch main.py
nano main.py
```

**поставете в main.py следния код:**

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

### ▶️ 2.2. Стартиране на тестов сървър

```bash
cd ~/NetGalaxyUP
curl -fsSL https://NetGalaxySoft:<TOKEN>@raw.githubusercontent.com/NetGalaxySoft/servers/main/scripts/fastapi-autostart.sh -o scripts/fastapi-autostart.sh
chmod +x scripts/fastapi-autostart.sh
./scripts/fastapi-autostart.sh 8000
```

---

### 🌐 2.3. Тест на сървъра
`http://<IP_ADDRESS>:8000`

трябва да върне:
{"status": "ok"}

`http://<IP_ADDRESS>:8000/health`

трябва да върне:
{"app": "NetGalaxyUP", "status": "ok"}

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
● Cancel operation
○ Remove existing files and continue
○ Ignore files and continue
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

## ✅ 3.5. Проверка с тестово стартиране

```bash
# 🚀 Стартиране на Vite сървъра чрез systemd (порт 5173)
cd ~/NetGalaxyUP
./scripts/fastapi-autostart.sh 5173
```

След това отворете:

```
`http://<IP_ADDRESS>:5173`
```

Трябва да се визуализира началният React екран (съобщение: *Vite + React*).

---

Перфектно — сега ще създадем основните компоненти в `src/components/`, както ги описахме в архитектурата.

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
cd NetGalaxyUP
./fastapi-autostart.sh 5173

```

Отвори в браузъра:
📍 `http://localhost:5173`

Трябва да виждаш:

* горна лента с надпис **NetGalaxyUP**
* зелена странична лента **Навигация**
* работна зона със съдържание
* долен червен футър

---

Готово! Това е **минимален, но функционален скелет** на приложението NetGalaxyUP, изграден по всички правила.

Да продължим ли със следващата стъпка: създаване на първия `package` (напр. `Login`) или добавяне на езикови файлове (`languages/`)?


## ✅ Стъпка 7: Създаване на основните компоненти на потребителския интерфейс (UI)

В тази стъпка се изгражда визуалният скелет на приложението NetGalaxyUP чрез отделни компоненти, които ще бъдат вграждани в основния шаблон `index.html`. Всеки компонент е структуриран в отделен файл (или директория) в папката `components/`, което улеснява поддръжката, редактирането и визуалното разграничаване.

### Основни компоненти:

| Компонент    | Файл                        | Описание                                   |
| ------------ | --------------------------- | ------------------------------------------ |
| 🎯 TopBar    | `components/TopBar.html`    | Горен бар с място за менюта и езиков избор |
| 📚 SideBar   | `components/SideBar.html`   | Ляво навигационно меню за модулите         |
| 📉 Footer    | `components/Footer.html`    | Долна лента с допълнителна информация      |
| 📄 Workspace | `components/Workspace.html` | Зона за зареждане на съдържание            |

### Характеристики:

* Компонентите се създават с **Tailwind CSS**
* Всеки елемент използва **различен цвят**, за да се избере подходяща финална тема
* Без излишни HTML структури – **само основата** за изграждане на документ за идентификация, а не класически уебсайт
 
Точно така — абсолютно правилно. Ето ти сега **реална, изпълнима Стъпка 7** с конкретни **инструкции и съдържание на файловете**, годна директно за документацията:

---



---

Тези компоненти ще бъдат включени в основния шаблон `index.html` в **следващата стъпка** (Стъпка 8), където ще се зареждат чрез Jinja2 `{% include %}`.

---



---

## ✅ Автоматично стартиране на скелета на порт 5173

```bash
curl -fsSL https://NetGalaxySoft:<TOKEN>@raw.githubusercontent.com/NetGalaxySoft/servers/main/fastapi-autostart.sh -o fastapi-autostart.sh
chmod +x fastapi-autostart.sh
./fastapi-autostart.sh 5173
```

> 🔁 Скриптът ще създаде услуга `netgalaxyup5173`, която ще стартира автоматично при всеки рестарт.

---

## ✅ Готово! Проверете резултата в браузъра:

```
http://5.189.160.200:5173/
```

трябва да видите визуалния скелет на приложението.

---

Готов ли си да продължим с добавяне на динамични елементи (език, логин зона и т.н.) или първо да запишем това в `develop.md`?


### Изтриване на проекта!
```bash
# ⛔️ Спиране и премахване на бекенд FastAPI сървър
sudo systemctl stop netgalaxyup8000
sudo systemctl disable netgalaxyup8000
sudo rm /etc/systemd/system/netgalaxyup8000.service

# ⛔️ Спиране и премахване на фронтенд Vite сървър
sudo systemctl stop netgalaxyup5173
sudo systemctl disable netgalaxyup5173
sudo rm /etc/systemd/system/netgalaxyup5173.service

# 🔄 Презареждане на systemd
sudo systemctl daemon-reload

# 🗑️ Изтриване на проекта
cd ~
sudo rm -rf NetGalaxyUP

```
