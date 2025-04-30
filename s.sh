

# 1. Zainicjuj repozytorium
git init

# 2. Dodaj remote do GitHub, jeśli jeszcze nie dodałeś:
git remote add origin git@github.com:suninweb/ghcr-beta3.git

# 3. Dodaj i zatwierdź pliki
git add .
git commit -m "Initial commit for GHCR test"

# 4. Push na main
git push -u origin main





git add .
git commit -m "Add Docker + GHCR workflow"
git push origin main