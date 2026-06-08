#!/usr/bin/env bash

# PHP Technical Test - Solution Launcher
# Compatible with Linux, macOS, and WSL (Windows)
# ==================================================

set -e

echo "============================================"
echo "  PHP Technical Test - Solution Launcher"
echo "============================================"
echo ""

# --- Detect PHP ---
if ! command -v php &>/dev/null; then
    echo "[ERROR] PHP not found."
    echo "  Install PHP:"
    echo "    macOS: brew install php"
    echo "    Ubuntu/Debian: sudo apt install php-cli php-mysql"
    echo "    Fedora: sudo dnf install php-cli php-mysql"
    echo "  Or use XAMPP/MAMP."
    exit 1
fi
PHPVER=$(php -r "echo PHP_VERSION;")
echo "[OK] PHP $PHPVER found"
echo ""

# --- Detect MySQL ---
MYSQL_FOUND=0
MYSQL_CMD=""

# Check common locations
MYSQL_PATHS=(
    "/usr/local/mysql/bin"
    "/usr/local/bin"
    "/usr/bin"
    "/opt/homebrew/bin"
    "/Applications/XAMPP/xamppfiles/bin"
    "/Applications/MAMP/Library/bin"
    "/snap/bin"
)

if command -v mysql &>/dev/null; then
    MYSQL_CMD=$(command -v mysql)
    MYSQL_FOUND=1
    echo "[OK] MySQL found in PATH: $MYSQL_CMD"
else
    for p in "${MYSQL_PATHS[@]}"; do
        if [ -x "$p/mysql" ]; then
            export PATH="$p:$PATH"
            MYSQL_CMD="$p/mysql"
            MYSQL_FOUND=1
            echo "[OK] MySQL found at: $p"
            break
        fi
    done
fi

if [ "$MYSQL_FOUND" -eq 0 ]; then
    echo "[WARN] MySQL not found."
    echo "  Exercises requiring a database will NOT work."
    echo "  Install:"
    echo "    macOS: brew install mysql"
    echo "    Ubuntu/Debian: sudo apt install mysql-server"
    echo "    Fedora: sudo dnf install mysql-server"
    echo ""
    echo "  To review code only, open the .php files in your editor."
    exit 1
fi

# --- Test MySQL connection ---
echo ""
echo "Testing MySQL connection..."
if ! mysql -u root -h 127.0.0.1 -e "SELECT 1;" &>/dev/null; then
    echo "[WARN] MySQL is not running."
    echo "  Start MySQL:"
    echo "    macOS: brew services start mysql"
    echo "    Linux: sudo systemctl start mysql"
    echo "    XAMPP: Open XAMPP Control Panel"
    echo ""
    echo "  Or review the code directly without a server."
    exit 1
fi
echo "[OK] MySQL connection successful"

# --- Ensure databases and tables exist ---
echo ""
echo "Checking 'training' database..."
if ! mysql -u root -h 127.0.0.1 -e "SELECT COUNT(*) FROM training.items;" &>/dev/null; then
    echo "Creating training database and importing data..."
    mysql -u root -h 127.0.0.1 -e "CREATE DATABASE IF NOT EXISTS training CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    mysql -u root -h 127.0.0.1 training --default-character-set=utf8mb4 < "solucion prueba tecnica/store.sql"
    echo "[OK] training database ready"
else
    echo "[OK] training database exists"
fi

echo "Checking 'challenge' database..."
if ! mysql -u root -h 127.0.0.1 -e "SELECT COUNT(*) FROM challenge.products;" &>/dev/null; then
    echo "Creating challenge database and importing data..."
    mysql -u root -h 127.0.0.1 -e "CREATE DATABASE IF NOT EXISTS challenge CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    mysql -u root -h 127.0.0.1 challenge --default-character-set=utf8mb4 < "solucion challenge 2 junior-main/data.sql"
    echo "[OK] challenge database ready"
else
    echo "[OK] challenge database exists"
fi

# --- Choose exercise ---
echo ""
echo "============================================"
echo "  SELECT AN EXERCISE:"
echo "============================================"
echo ""
echo "  1) Technical Test 1 - Items & Invoices"
echo "  2) Challenge 2 Junior - Products & Orders"
echo "  3) Quit"
echo ""
read -p "Choose (1-3): " CHOICE

case "$CHOICE" in
    1)
        PORT=8000
        DIR="solucion prueba tecnica"
        FILE="challenge.php"
        ;;
    2)
        PORT=8001
        DIR="solucion challenge 2 junior-main"
        FILE="challenge.php"
        ;;
    *)
        echo "Exiting..."
        exit 0
        ;;
esac

# --- Start PHP server ---
echo ""
echo "Starting server at http://localhost:$PORT/$FILE"
echo "Open your browser to that address."
echo "Press Ctrl+C to stop the server."
echo ""
php -S localhost:$PORT -t "$DIR"
