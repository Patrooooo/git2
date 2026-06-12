#!/bin/bash

SCRIPT_NAME=$(basename "$0")
REPO_URL="https://github.com/Patrooooo/git2.git"

show_help() {
    echo "========================================"
    echo "  $SCRIPT_NAME – dostępne opcje"
    echo "========================================"
    echo ""
    echo "  --date,  -d           Wyświetla dzisiejszą datę"
    echo "  --logs,  -l  [N]      Tworzy N plików logx.txt (domyślnie 100)."
    echo "                        Każdy plik zawiera swoją nazwę, nazwę skryptu i datę."
    echo "  --error, -e  [N]      Tworzy N katalogów errorx/ z plikami errorx.txt"
    echo "                        (domyślnie 100). Struktura analogiczna jak --logs."
    echo "  --init                Klonuje repozytorium do bieżącego katalogu"
    echo "                        i dodaje jego ścieżkę do zmiennej PATH (~/.bashrc)."
    echo "  --help,  -h           Wyświetla tę pomoc."
    echo ""
    echo "Przykłady:"
    echo "  $SCRIPT_NAME --date"
    echo "  $SCRIPT_NAME --logs"
    echo "  $SCRIPT_NAME --logs 30"
    echo "  $SCRIPT_NAME -l 30"
    echo "  $SCRIPT_NAME --error"
    echo "  $SCRIPT_NAME --error 30"
    echo "  $SCRIPT_NAME -e 30"
    echo "  $SCRIPT_NAME --init"
    echo "  $SCRIPT_NAME --help"
    echo ""
}

show_date() {
    echo "Dzisiejsza data: $(date '+%Y-%m-%d %H:%M:%S')"
}


create_logs() {
    local count=${1:-100}

    # Walidacja – czy argument jest liczbą całkowitą dodatnią
    if ! [[ "$count" =~ ^[1-9][0-9]*$ ]]; then
        echo "Błąd: Argument musi być liczbą całkowitą większą od 0 (podano: '$count')."
        exit 1
    fi

    echo "Tworzenie $count pliku(-ów) logów..."
    for i in $(seq 1 "$count"); do
        local filename="log${i}.txt"
        {
            echo "Nazwa pliku:  $filename"
            echo "Skrypt:       $SCRIPT_NAME"
            echo "Data:         $(date '+%Y-%m-%d %H:%M:%S')"
        } > "$filename"
    done
    echo "Gotowe. Utworzono $count plik(ów) log*.txt."
}

create_errors() {
    local count=${1:-100}

    # Walidacja
    if ! [[ "$count" =~ ^[1-9][0-9]*$ ]]; then
        echo "Błąd: Argument musi być liczbą całkowitą większą od 0 (podano: '$count')."
        exit 1
    fi

    echo "Tworzenie $count katalogu(-ów) błędów..."
    for i in $(seq 1 "$count"); do
        local dirname="error${i}"
        local filename="${dirname}.txt"
        mkdir -p "$dirname"
        {
            echo "Nazwa pliku:  $filename"
            echo "Skrypt:       $SCRIPT_NAME"
            echo "Data:         $(date '+%Y-%m-%d %H:%M:%S')"
        } > "${dirname}/${filename}"
    done
    echo "Gotowe. Utworzono $count katalogu(-ów) error*/ z plikami error*.txt."
}


init_repo() {
    echo "Klonowanie repozytorium: $REPO_URL"
    git clone "$REPO_URL" .
    if [ $? -ne 0 ]; then
        echo "Błąd: Klonowanie nie powiodło się."
        exit 1
    fi

    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

    # Dodaj do PATH jeśli jeszcze nie istnieje
    if echo "$PATH" | grep -q "$SCRIPT_DIR"; then
        echo "Ścieżka '$SCRIPT_DIR' już istnieje w PATH – pomijam."
    else
        export PATH="$PATH:$SCRIPT_DIR"
        echo "export PATH=\"\$PATH:$SCRIPT_DIR\"" >> ~/.bashrc
        echo "Dodano '$SCRIPT_DIR' do PATH (pamiętaj: source ~/.bashrc lub otwórz nowy terminal)."
    fi
}


if [ $# -eq 0 ]; then
    echo "Brak argumentów. Użyj: $SCRIPT_NAME --help"
    exit 1
fi

case "$1" in
    --date|-d)
        show_date
        ;;
    --logs|-l)
        create_logs "$2"
        ;;
    --error|-e)
        create_errors "$2"
        ;;
    --init)
        init_repo
        ;;
    --help|-h)
        show_help
        ;;
    *)
        echo "Nieznana opcja: '$1'"
        echo "Użyj '$SCRIPT_NAME --help' aby zobaczyć dostępne opcje."
        exit 1
        ;;
esac
