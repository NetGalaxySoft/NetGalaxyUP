#!/bin/bash

# ==========================================================================
#  install-netgalaxyup.sh – Автоматична инсталация на проекта NetGalaxyUP
# --------------------------------------------------------------------------
#  Версия: 1.5
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

  export GIT_ASKPASS="$(mktemp)"
  echo "#!/bin/bash" > "$GIT_ASKPASS"
  echo "echo $GITHUB_TOKEN" >> "$GIT_ASKPASS"
  chmod +x "$GIT_ASKPASS"

  GIT_TERMINAL_PROMPT=0 git clone https://github.com/NetGalaxySoft/NetGalaxyUP.git

  rm -f "$GIT_ASKPASS"
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

# Финално съобщение
echo "=================================================================="
echo " ✅ Инсталацията на NetGalaxyUP е завършена успешно."
echo "=================================================================="
