#!/bin/bash

# Set non-interactive for timezone
export DEBIAN_FRONTEND=noninteractive
ln -fs /usr/share/zoneinfo/Asia/Kathmandu /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

# Update and install required packages
apt-get update
apt-get install -y tmate expect netcat

# Start tmate session in background
tmate -S /tmp/tmate.sock new-session -d
tmate -S /tmp/tmate.sock wait tmate-ready

# Print tmate session URLs
echo "==================================="
echo "✅ SSH access:"
tmate -S /tmp/tmate.sock display -p "#{tmate_ssh}"
echo "🌐 Web access (read+write):"
tmate -S /tmp/tmate.sock display -p "#{tmate_web}"
echo "==================================="

# Background loop to keep session alive via keypress simulation
(
  while true; do
    tmate -S /tmp/tmate.sock send-keys "echo alive && date" C-m
    sleep 300
  done
) &

# Dummy HTTP server to satisfy Render port scanner (port 8080)
echo "🌀 Starting dummy server on port 8080 to keep Render alive..."
while true; do
  echo -e "HTTP/1.1 200 OK\n\n✅ Remote Dev Environment is Active." | nc -l -p 8080
done
