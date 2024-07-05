#!/bin/bash

# Array of URLs
urls=(
  "https://earnapp.com/r/sdk-node-f990e57aa8e38f8eb57354daf09e4b19"
)

# Function to open URL in browser
open_url() {
  termux-open-url "$1"
}

# Loop through each URL
for (( i=0; i<${#urls[@]}; i++ )); do
  # Display current link number
  echo "Membuka link ke-$((i+1)) dari ${#urls[@]}"
  
  # Open URL
  open_url "${urls[$i]}"
  
  # Check if we need to sleep
  if (( ($i + 1) % 5 == 0 && ($i + 1) < ${#urls[@]} )); then
    echo "Menunggu selama 5 menit..."
    sleep 300  # Sleep for 5 minutes
  elif (( ($i + 1) < ${#urls[@]} )); then
    echo "Menunggu selama 10 detik..."
    sleep 10   # Sleep for 10 seconds
  fi
done

echo "Selesai!"
