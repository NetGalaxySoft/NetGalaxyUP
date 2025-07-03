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
mkdir -p NetGalaxyUP/{backend,frontend/components/{layout,shared},frontend/public,languages,packages}

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
NetGalaxyUP/
├── backend/                    # FastAPI сървър (API бекенд)
│   └── main.py                # Начален API файл
├── frontend/                  # Клиентска част (PWA интерфейс)
│   ├── components/            # Компоненти на интерфейса
│   │   ├── layout/            # Основни елементи: TopBar, SideBar, Footer
│   │   └── shared/            # Общи елементи: известия и други
│   └── public/                # Статични ресурси (favicon, manifest и др.)
├── languages/                 # JSON файлове с езикови преводи
├── packages/                  # Основни пакети (напр. login, profile)
└── README.md                  # Документация на проекта
```

🛡️ Настройка на права за съвместна разработка
След създаване на структурата е необходимо да се зададат правилни права за достъп до проекта, така че всички участници в групата netgalaxyup да имат достъп без използване на sudo.

---

## ✅ Стъпка 2: Инициализиране на FastAPI проект (backend)

```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install fastapi uvicorn
```

### Създаване на началния файл на приложението:
```bash
touch main.py
nano main.py
```

### поставете в main.py следния код:

```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"app": "NetGalaxyUP", "status": "ok"}

@app.get("/health")
def read_health():
    return {"status": "ok"}
```

### ▶️ Стартиране на тестов сървър

```bash
curl -fsSL https://NetGalaxySoft:<TOKEN>@raw.githubusercontent.com/NetGalaxySoft/servers/main/fastapi-autostart.sh -o fastapi-autostart.sh
chmod +x fastapi-autostart.sh
./fastapi-autostart.sh 8000
```

---

### 🌐 Тест на сървъра
`http://<IP-АДРЕС>:8000/`

трябва да върне:
{"status": "ok"}

`http://<IP-АДРЕС>:8000/health`

трябва да върне:
{"app": "NetGalaxyUP", "status": "ok"}

---

Ето пълния текст за `develop.md`, **Стъпка 3: Описание на основните елементи и архитектура на приложението NetGalaxyUP**, подготвен по твоите изисквания:

---

## 🧩 Стъпка 3: Описание на основните елементи и архитектура на приложението NetGalaxyUP

### 🎯 Основни визуални елементи на интерфейса

Приложението NetGalaxyUP е мобилно уеб приложение (PWA), предназначено за достъп и управление на сървърни Control Panel системи. Интерфейсът му е изцяло адаптиран за мобилни устройства и се състои от следните основни елементи:

* **🎯 Лого бар** – разположен в горния ляв ъгъл. Използва се за визуална идентификация на платформата.
* **📏 Горен бар (Topbar)** – съдържа:

  * менюта за навигация
  * потребителски опции (вход, профил и др.)
  * избор на език (зареден от сървъра)
  * бързи действия и контрол върху packages (виж по-долу)
* **📚 Главно навигационно меню (Sidebar)** – разположено отляво; предоставя достъп до основните модули и секции.
* **🧭 Допълнително навигационно меню (Submenu)** – показва се само в определени секции, когато е необходимо вътрешно разклонение на даден модул (напр. настройки, подсекции и др.)
* **📄 Работно пространство (Workspace)** – централната зона, в която се зарежда динамичното съдържание на избрания модул.

---

### 🧱 Видове модули и архитектурна логика

Модулите в системата са разделени на два основни вида:

#### 1. `packages` – задължителни модули:

* Това са основните компоненти на системата, без които приложението не може да функционира.
* Те се зареждат автоматично при стартиране на приложението.
* Обикновено се разполагат в **горната лента (Topbar)**, но някои могат да присъстват и в страничното меню.

#### 2. `modules` – условни модули:

* Те се инсталират при определени условия – например дали потребителят има необходимите права или дали приложението е лицензирано.
* Обикновено се разполагат в **лявата навигационна лента (Sidebar)**, но при нужда могат да се появят и в **Topbar** или **Footer**.

---

### 🛢️ База данни на приложението

Приложението използва **собствена база данни**, в която се съхраняват:

* Данни за легитимността и лицензираността на приложението
* Информация за активираните `packages` и `modules`
* Потребителски настройки и предпочитания (напр. език, тема)
* Всички необходими данни за динамичното зареждане на елементи и проверка на достъп

---

### 🛠️ Използвани технологии

* **Тип приложение:** Progressive Web App (PWA)
* **CSS фреймуърк:** Tailwind CSS
* **Фокус:** мобилен-first дизайн, с приоритет на бързина, адаптивност и модулност

---

Сега ще изградим напълно работеща структура в `~/NetGalaxyUP/frontend/`, така че при стартиране на порт 5173 да виждате **графичен интерфейс (скелет)** на NetGalaxyUP.

---

## 🧱 Структурата:

```
NetGalaxyUP/
└── frontend/
    ├── main.py
    ├── venv/
    └── templates/
        └── index.html
```

---

## ✅ Стъпка 4: Създаване на директория и активиране на виртуална среда

```bash
cd ~/NetGalaxyUP
mkdir -p frontend/templates
cd frontend
python3 -m venv venv
source venv/bin/activate
pip install fastapi uvicorn jinja2
```

---

## ✅ Стъпка 5: Създаване на файл `main.py` във `frontend/`

```bash
nano main.py
```

Поставете в него следния код:

```python
from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates

app = FastAPI()
templates = Jinja2Templates(directory="templates")

@app.get("/", response_class=HTMLResponse)
async def show_home(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})
```

---

## ✅ Стъпка 6: Създаване на файл `templates/index.html`

```bash
nano templates/index.html
```

Поставете този примерен скелет:

```html
<!DOCTYPE html>
<html lang="bg">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>NetGalaxyUP</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 text-gray-800">

  <!-- 🎯 Topbar с лого -->
  <header class="bg-white shadow p-4 flex justify-between items-center">
    <div class="text-xl font-bold text-blue-600">🌌 NetGalaxyUP</div>
    <div class="text-sm text-gray-600">[Потребител/Език]</div>
  </header>

  <!-- 📚 Навигация -->
  <nav class="bg-white p-2 flex space-x-2 overflow-x-auto">
    <button class="px-3 py-1 bg-blue-100 rounded">Dashboard</button>
    <button class="px-3 py-1 bg-gray-100 rounded">Модул 1</button>
    <button class="px-3 py-1 bg-gray-100 rounded">Модул 2</button>
  </nav>

  <!-- 🧭 Подменю -->
  <div class="p-2 flex space-x-2">
    <button class="px-2 py-1 bg-gray-200 rounded">Подменю A</button>
    <button class="px-2 py-1 bg-gray-200 rounded">Подменю B</button>
  </div>

  <!-- 📄 Работна зона -->
  <main class="p-4">
    <div class="bg-white p-4 rounded shadow">
      <h1 class="text-xl font-semibold">Добре дошъл!</h1>
      <p class="mt-2 text-sm text-gray-600">
        Това е началният скелет на приложението NetGalaxyUP.
      </p>
    </div>
  </main>

</body>
</html>
```

---

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

### 📁 Създаване на директориите:

```bash
mkdir -p frontend/components/layout
mkdir -p frontend/components/workspace
```

---

### 📄 Създаване на `TopBar.html`

```bash
sudo nano frontend/components/layout/TopBar.html
```

Добавете следния код:

```html
<div class="w-full h-16 bg-blue-300 flex items-center px-4 shadow">
  <span class="font-bold text-lg text-white">NetGalaxyUP</span>
</div>
```

---

### 📄 Създаване на `SideBar.html`

```bash
sudo nano frontend/components/layout/SideBar.html
```

Добавете следния код:

```html
<div class="w-48 bg-green-300 h-full p-4">
  <p class="font-semibold text-white">Навигация</p>
</div>
```

---

### 📄 Създаване на `Workspace.html`

```bash
sudo nano frontend/components/workspace/Workspace.html
```

Добавете следния код:

```html
<div class="flex-1 bg-gray-100 p-6">
  <p class="text-gray-800">Работно пространство</p>
</div>
```

---

### 📄 Създаване на `Footer.html`

```bash
sudo nano frontend/components/layout/Footer.html
```

Добавете следния код:

```html
<div class="w-full h-12 bg-red-300 flex items-center justify-center text-white">
  © 2025 NetGalaxyUP
</div>
```

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
cd ~
sudo rm -rf NetGalaxyUP
```
