#!/bin/bash

# 1. Periksa apakah file uuidnew.txt ada di repository GitHub
repo_owner="belajarit45"
repo_name="database1"
file_path="uuidnew.txt"
github_token="YOUR_GITHUB_TOKEN"

file_exists=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: token $github_token" "https://api.github.com/repos/$repo_owner/$repo_name/contents/$file_path")

if [ $file_exists -ne 200 ]; then
    echo "File uuidnew.txt tidak ditemukan di GitHub repo $repo_owner/$repo_name."
    exit 1
fi

# 2. Ambil UUID yang sesuai dengan pola sdk-android-$uuid dari file uuidnew.txt
uuids=$(curl -s -H "Authorization: token $github_token" "https://api.github.com/repos/$repo_owner/$repo_name/contents/$file_path" | jq -r '.content' | base64 -d | grep -oP 'sdk-android-\K\w+')

if [ -z "$uuids" ]; then
    echo "Tidak ada UUID yang sesuai ditemukan dalam file uuidnew.txt di GitHub repo $repo_owner/$repo_name."
    exit 1
fi

# 3. Buat docker-compose.yaml
echo "services:" > docker-compose.yaml

i=1
for uuid in $uuids; do
    cat >> docker-compose.yaml << EOF
  earnapp_$i:
    container_name: earnapp-container_$i
    image: fazalfarhan01/earnapp:lite
    restart: always
    volumes:
      - earnapp-data:/etc/earnapp
    environment:
      EARNAPP_UUID: $uuid
EOF
    i=$((i+1))
done

echo "volumes:" >> docker-compose.yaml
echo "  earnapp-data:" >> docker-compose.yaml

# 4. Jalankan docker-compose up -d
docker-compose up -d

# 5. Buat URL dan kirim menggunakan token ke GitHub
for uuid in $uuids; do
    url="https://earnapp.com/r/$uuid"
    echo $url >> earnapplinkupdate.txt
done

# Kirim file earnapplinkupdate.txt ke GitHub
curl -X PUT \
    -H "Authorization: token $github_token" \
    -d @earnapplinkupdate.txt \
    "https://api.github.com/repos/$repo_owner/$repo_name/contents/earnapplinkupdate.txt"

echo "Proses selesai."
