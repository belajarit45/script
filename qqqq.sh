#!/bin/bash

# Array of URLs
urls=(
  "https://earnapp.com/r/sdk-node-a4440cfc329f49ecbc349e43f90c9c25"
  "https://earnapp.com/r/sdk-node-a5d04caa43a64867bc008c0f533e33b6"
  "https://earnapp.com/r/sdk-node-693434f335914a07872ca17b554c5748"
  "https://earnapp.com/r/sdk-node-80b9d5b677a94bd68c3baaa77511cea7"
  "https://earnapp.com/r/sdk-node-6c6a7d495c0843e5bdc3b869bdaf5a05"
)

# Function to open URL in browser
open_url() {
  termux-open-url "$1"
}

# Loop through each URL
for (( i=0; i<${#urls[@]}; i++ )); do
  # Display current link number
  echo "Opening link number $((i+1)) out of ${#urls[@]}"
  
  # Open URL
  open_url "${urls[$i]}"
  
  # Check if we need to sleep
  if (( ($i + 1) % 5 == 0 && ($i + 1) < ${#urls[@]} )); then
    echo "Waiting for 5 minutes..."
    sleep 300  # Sleep for 5 minutes
  elif (( ($i + 1) < ${#urls[@]} )); then
    echo "Waiting for 10 seconds..."
    sleep 10   # Sleep for 10 seconds
  fi
done

echo "Done!"
