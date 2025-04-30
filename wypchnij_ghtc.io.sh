#!/bin/bash

# Załaduj zmienne środowiskowe z pliku .env (jeśli istnieje)
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs -n 1)
  echo "Załadowano zmienne środowiskowe z pliku .env"
fi

# Domyślne wartości zmiennych, jeśli nie są ustawione w .env
ORG="${ORG:-myappbots}"
TOKEN="${TOKEN:-ghp_A6DEPAdWLL9vX6LzahM11r1GrC}"
NAME="${NAME:-ghcr-test}"
DESC="${DESC:-Repo do testów GHCR}"
GIT_COMM_INIT="${GIT_COMM_INIT:-"Initial commit 1"}"
GIT_COMM_ADD="${GIT_COMM_ADD:-"Add Docker + GHCR workflow"}"
GITHUB_TOKEN="${GITHUB_TOKEN:-github_pat_11AA2CdaRDdIAo3UMlsqjzMfGa1aEuGuUMMOITUeaOun3EKJI6EFIBu7ZKrTN}"
GITHUB_USERNAME="${GITHUB_USERNAME:-suninweb}"
IMAGE_NAME="${IMAGE_NAME:-your_image_name_testow}"
TAG="${TAG:-v1}"

# Zbuduj GITHUB_URL na podstawie ORG i NAME
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

# logowanie do ghcr.io
if [ -n "$GITHUB_TOKEN" ] && [ -n "$GITHUB_USERNAME" ]; then
  echo "$GITHUB_TOKEN" | docker login ghcr.io -u "$GITHUB_USERNAME" --password-stdin
  if [ $? -eq 0 ]; then
    echo "Pomyślnie zalogowano do ghcr.io"
  else
    echo "Błąd logowania do ghcr.io"
  fi
else
  echo "Nie ustawiono GITHUB_TOKEN lub GITHUB_USERNAME. Nie można zalogować się do ghcr.io."
fi

# budowanie obrazu
if [ -n "$GITHUB_USERNAME" ] && [ -n "$IMAGE_NAME" ] && [ -n "$TAG" ]; then
  docker build -t "ghcr.io/$GITHUB_USERNAME/$IMAGE_NAME:$TAG" .
  if [ $? -eq 0 ]; then
    echo "Pomyślnie zbudowano obraz: ghcr.io/$GITHUB_USERNAME/$IMAGE_NAME:$TAG"
  else
    echo "Błąd podczas budowania obrazu"
  fi
else
  echo "Nie ustawiono GITHUB_USERNAME, IMAGE_NAME lub TAG. Nie można zbudować obrazu."
fi

# push obrazu
if [ -n "$GITHUB_USERNAME" ] && [ -n "$IMAGE_NAME" ] && [ -n "$TAG" ]; then
  docker push "ghcr.io/$GITHUB_USERNAME/$IMAGE_NAME:$TAG"
  if [ $? -eq 0 ]; then
    echo "Pomyślnie wypchnięto obraz: ghcr.io/$GITHUB_USERNAME/$IMAGE_NAME:$TAG"
  else
    echo "Błąd podczas wypychania obrazu"
  fi
else
  echo "Nie ustawiono GITHUB_USERNAME, IMAGE_NAME lub TAG. Nie można wypchnąć obrazu."
fi

echo "--------------------------------------------------"
echo "Operacje na obrazie Docker w ghcr.io zakończone (jeśli zostały wykonane)."