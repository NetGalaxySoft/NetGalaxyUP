#!/bin/bash

# ==========================================================================
#  install-netgalaxyup.sh – Автоматична инсталация на проекта NetGalaxyUP
# --------------------------------------------------------------------------
#  Версия: 1.7
#  Дата: 2025-07-02
#  Автор: Ilko Yordanov / NetGalaxy
# ==========================================================================
#
#  Скриптът клонира проекта NetGalaxyUP от GitHub, инсталира нужните
#  зависимости и подготвя средата. Работи без интеракция.
# ==========================================================================

set -e

echo "=================================================================="
echo " 🚀 NetGalaxyUP – Автоматична инсталация"
echo "=================================================================="

# Очакваме GitHub токен като аргумент
GITHUB_TOKEN="$1"

if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "❌ Липсва GitHub токен като аргумент."
  echo "   Използвай следния синтаксис:"
  echo
  echo "   bash install-netgalaxyup.sh <GITHUB_TOKEN>"
  echo
  exit 1
fi

# Създаване на директория ~/projects ако не съществува
mkdir -p ~/projects
cd ~/projects || exit 1

# Проверка дали проектът вече съществува
if [[ -d "NetGalaxyUP" ]]; then
  echo "✅ Проектът NetGalaxyUP вече съществува. Пропускане на клонирането."
else
  echo "⏳ Клониране на проекта от GitHub..."

  ASKPASS_SCRIPT="$(mktemp)"
  echo "#!/bin/bash" > "$ASKPASS_SCRIPT"
  echo "echo $GITHUB_TOKEN" >> "$ASKPASS_SCRIPT"
  chmod +x "$ASKPASS_SCRIPT"

  export GIT_ASKPASS="$ASKPASS_SCRIPT"
  export GIT_USERNAME="NetGalaxySoft"
  GIT_TERMINAL_PROMPT=0 git clone https://github.com/NetGalaxySoft/NetGalaxyUP.git

  rm -f "$ASKPASS_SCRIPT"
fi

cd NetGalaxyUP || exit 1

# Инсталиране на backend зависимости
echo "=================================================================="
echo " 🐍 Инсталиране на Python зависимости (backend)..."
echo "=================================================================="
cd backend || exit 1
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
cd ..

# Инсталиране на frontend зависимости
echo "=================================================================="
echo " 💻 Инсталиране на Node зависимости (frontend)..."
echo "=================================================================="
cd frontend || exit 1
npm install
cd ..

# Извличане на публичния IP адрес
SERVER_IP=$(hostname -I | awk '{print $1}')

# Стартиране на backend сървъра (Uvicorn)
echo "=================================================================="
echo " 🔄 Стартиране на backend сървъра (Uvicorn)..."
echo "=================================================================="
cd backend || exit 1
source venv/bin/activate
nohup uvicorn src.app:app --host 0.0.0.0 --port 8000 --reload > ../backend.log 2>&1 &
deactivate
cd ..
echo "✅ Backend сървърът работи на: http://$SERVER_IP:8000"

# Стартиране на frontend сървъра (Vite)
echo "=================================================================="
echo " 🔄 Стартиране на frontend сървъра (Vite)..."
echo "=================================================================="
cd frontend || exit 1
nohup npm run dev -- --host 0.0.0.0 --port 5173 > ../frontend.log 2>&1 &
cd ..
echo "✅ Frontend сървърът работи на: http://$SERVER_IP:5173"

# Финално съобщение
echo "=================================================================="
echo " ✅ Инсталацията на NetGalaxyUP е завършена успешно."
echo "=================================================================="
