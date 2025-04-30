export TOKEN=$(grep "^TOKEN=" .env | cut -d '=' -f 2)
curl -H "Authorization: token $TOKEN" \
     -H "Accept: application/vnd.github+json" \
     https://api.github.com/user/repos \
     -d '{"name":"ghcr-beta3","private":false}'