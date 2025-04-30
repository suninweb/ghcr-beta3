#!/bin/bash

# Załaduj zmienne środowiskowe z pliku .env (jeśli istnieje)
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs -n 1)
  echo "Załadowano zmienne środowiskowe z pliku .env"
fi

# Domyślne wartości zmiennych, jeśli nie są ustawione w .env
# GITHUB_URL="${GITHUB_URL:-}"
GIT_COMM_INIT="${GIT_COMM_INIT:-"Initial commit"}"
GIT_COMM_ADD="${GIT_COMM_ADD:-"Add Docker + GHCR workflow"}"


if [ -n "$ORG" ] && [ -n "$NAME" ]; then
  export GITHUB_URL="https://github.com/$ORG/$NAME.git"
  echo "Ustawiono GITHUB_URL na: $GITHUB_URL"
else
  echo "Nie można zbudować GITHUB_URL. Zmienne ORG i/lub NAME nie są ustawione."
fi


# 1. Zainicjuj repozytorium
git init
git branch -m master main
echo "Zainicjowano lokalne repozytorium Git i zmieniono nazwę gałęzi 'master' na 'main'."

#2. Dodaj zdalne repozytorium (jeśli jeszcze nie istnieje)
if git remote get-url origin > /dev/null 2>&1; then
  echo "Zdalne repozytorium 'origin' już istnieje."
else
  if [ -n "$GITHUB_URL" ]; then
    git remote add origin "$GITHUB_URL"
    echo "Dodano zdalne repozytorium 'origin' z URL: $GITHUB_URL"
  else
    echo "Zmienna środowiskowa GITHUB_URL nie jest ustawiona. Nie można dodać zdalnego repozytorium."
  fi
fi

# 3. Dodaj wszystkie pliki do staging area
git add .
echo "Dodano wszystkie pliki do staging area."

# 4. Zatwierdź zmiany z opisem
if [ -z "$GIT_COMM_INIT" ]; then
  echo "Zmienna środowiskowa GIT_COMM_INIT nie jest ustawiona. Używam domyślnego opisu."
  git commit -m "Initial commit"
else
  git commit -m "$GIT_COMM_INIT"
  echo "Zatwierdzono zmiany z opisem: $GIT_COMM_INIT"
fi

# 5. Wypchnij zmiany do zdalnego repozytorium na gałąź 'main'
if git remote get-url origin > /dev/null 2>&1; then
  git push -u origin main
  echo "Wypchnięto zmiany do zdalnego repozytorium 'origin' na gałąź 'main'."
else
  echo "Nie można wypchnąć zmian. Zdalne repozytorium 'origin' nie zostało skonfigurowane."
fi

echo "--------------------------------------------------"

# Kolejne kroki (dodanie Dockera i workflow GHCR)
echo "Dodawanie Dockera i workflow GHCR..."
git add .
echo "Dodano pliki po dodaniu Dockera i workflow GHCR."
git commit -m "$GIT_COMM_ADD"
echo "Zatwierdzono zmiany: $GIT_COMM_ADD"
git push origin main
echo "Wypchnięto zmiany po dodaniu Dockera i workflow GHCR na gałąź 'main'."

echo "Zakończono."