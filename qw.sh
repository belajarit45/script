#!/bin/bash

# Step 1: Periksa apakah file uuidnew.txt ada di GitHub
if ! curl -s --head https://raw.githubusercontent.com/<username>/<repository>/main/uuidnew.txt | head -n 1 | grep "HTTP/1.[01] [23].." > /dev/null; then
  echo "File uuidnew.txt tidak ditemukan di GitHub. Proses dihentikan."
  exit 1
fi

# Step 2: Ambil UUID dari file uuidnew.txt di GitHub
uuid_list=$(curl -s https://raw.githubusercontent.com/<username>/<repository>/main/uuidnew.txt)

# Step 3: Loop untuk setiap UUID
i=1
for uuid in $uuid_list; do
  # Step 4: Periksa apakah UUID sdk-android-$uuid ada di dalam file uuidnew.txt
  if [[ $uuid == sdk-android-* ]]; then
    # Step 5: Buat file docker-compose.yaml
    cat << EOF > docker-compose.yaml
version: '3'
services:
  earnapp_$i:
    container_name: earnapp-container_$i
    image: fazalfarhan01/earnapp:lite
    restart: always
    volumes:
      - earnapp-data:/etc/earnapp
    environment:
      - EARNAPP_UUID: $uuid
volumes:
  earnapp-data:
EOF

    echo "docker-compose.yaml berhasil dibuat untuk UUID: $uuid"

    # Step 6: Jalankan docker-compose up -d untuk setiap container
    docker-compose up -d earnapp_$i
    echo "Container earnapp-container_$i berhasil dijalankan"

    ((i++))
  fi
done
