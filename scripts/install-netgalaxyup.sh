#!/bin/bash

# ==========================================================================
#  install-netgalaxyup.sh – Инсталация на NetGalaxyUP приложение
# --------------------------------------------------------------------------
#  Версия: 1.0
#  Дата: 2025-07-02
#  Автор: Ilko Yordanov / NetGalaxy
# ==========================================================================
#
#  Този скрипт автоматично клонира приложението NetGalaxyUP от GitHub,
#  инсталира всички нужни зависимости (Python и JavaScript), и подготвя
#  средата за стартиране на backend и frontend dev сървъри.
# ==========================================================================

echo "=================================================================="
echo " 🚀 NetGalaxyUP – Автоматична инсталация"
echo "=================================================================="

# Проверка за root права (не се изисква, но предупреждаваме)
if [[ "$EUID" -eq 0 ]]; then
  echo "⚠️ Препоръчително е скриптът да се изпълнява като обикновен потребител, не root."
fi

# Създаване на директория ~/projects ако не съществува
mkdir -p ~/projects
cd ~/projects || exit 1

# Ако проектът вече е клониран, пропускаме
if [[ -d "NetGalaxyUP" ]]; then
  echo "✅ Проектът NetGalaxyUP вече съществува в ~/projects. Пропускане на клонирането."
else
  echo "⏳ Клониране на проекта от GitHub..."
  git clone https://github.com/NetGalaxySoft/NetGalaxyUP.git
fi

cd NetGalaxyUP || exit 1

# === Инсталиране на backend зависимости ===
echo "=================================================================="
echo " 🐍 Инсталиране на Python зависимости (backend)..."
echo "=================================================================="

cd backend || exit 1
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip

if [[ -f "requirements.txt" ]]; then
  pip install -r requirements.txt
  echo "✅ Python зависимостите са инсталирани."
else
  echo "⚠️ Липсва файл requirements.txt – пропускам pip install."
fi

deactivate
cd ..

# === Инсталиране на frontend зависимости ===
echo "=================================================================="
echo " 🌐 Инсталиране на JavaScript зависимости (frontend)..."
echo "=================================================================="

cd frontend || exit 1
npm install
echo "✅ JavaScript зависимостите са инсталирани."
cd ..

# === Финално съобщение ===
echo "=================================================================="
echo "✅ Инсталацията на NetGalaxyUP е завършена успешно."
echo "📁 Проектът се намира в: ~/projects/NetGalaxyUP"
echo
echo "👉 Стартиране на backend:"
echo "   cd ~/projects/NetGalaxyUP/backend"
echo "   source venv/bin/activate"
echo "   uvicorn main:app --reload --host 0.0.0.0 --port 8000"
echo
echo "👉 Стартиране на frontend:"
echo "   cd ~/projects/NetGalaxyUP/frontend"
echo "   npm run dev"
echo
echo "=================================================================="
