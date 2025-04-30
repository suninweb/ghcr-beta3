export TOKEN=$(grep "^TOKEN=" .env | cut -d '=' -f 2)
export ORG=$(grep "^ORG=" .env | cut -d '=' -f 2)
export NAME=$(grep "^NAME=" .env | cut -d '=' -f 2)
export DESC=$(grep "^DESC=" .env | cut -d '=' -f 2)

curl -X POST \
  -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/orgs/$ORG/repos" \
  -d '{
    "name": "'"$NAME"'",
    "private": false,
    "auto_init": true,
    "description": "'"$DESC"'",
    "has_issues": true,
    "has_projects": true,
    "has_wiki": false
  }'