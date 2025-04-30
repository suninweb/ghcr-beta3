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