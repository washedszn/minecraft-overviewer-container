#!/bin/bash

# Log the UPDATE_SCHEDULE environment variable
echo "UPDATE_SCHEDULE=${UPDATE_SCHEDULE}"

# Export environment variables to a file
printenv | grep -v "no_proxy" >> /etc/environment

# Update the crontab file with the user-defined schedule
echo "${UPDATE_SCHEDULE} /bin/bash /app/update.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/update_cron

# Log the contents of the update_cron file for debugging
cat /etc/cron.d/update_cron

# Set the correct permissions and apply the crontab
chmod 0644 /etc/cron.d/update_cron
crontab /etc/cron.d/update_cron

# If textures.zip is not present in /data, download it
if [ ! -f /app/data/textures.zip ]; then
    echo "Downloading textures to /app/data"
    wget https://overviewer.org/textures/${MC_VERSION} -O /app/data/textures.zip
fi

# Run the update.sh script once immediately
/bin/bash /app/update.sh

# Start cron in the background
cron

# Tail the cron log file to keep it in the container logs
tail -f /var/log/cron.log &

# Start the web server
exec python3 -m http.server ${WEB_PORT} --directory /app/web
