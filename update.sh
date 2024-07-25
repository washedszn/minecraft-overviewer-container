#!/bin/bash

# Source the environment variables
source /etc/environment

# Log the start of the script
echo "Starting update.sh at $(date)" >> /var/log/cron.log
echo "Environment variables:" >> /var/log/cron.log
echo "FTP_HOST=${FTP_HOST}" >> /var/log/cron.log
echo "FTP_USERNAME=${FTP_USERNAME}" >> /var/log/cron.log
echo "FTP_PASSWORD=$(echo ${FTP_PASSWORD} | sed 's/./*/g')" >> /var/log/cron.log
echo "OVERWORLD=${OVERWORLD}" >> /var/log/cron.log
echo "NETHER=${NETHER}" >> /var/log/cron.log
echo "END=${END}" >> /var/log/cron.log

# Check if the config file exists
CONFIG_FILE="/app/config/config.py"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file $CONFIG_FILE does not exist. Exiting." >> /var/log/cron.log
    exit 1
fi

# URL-decode the FTP password
DECODED_FTP_PASSWORD=$(python3 -c "import urllib.parse; print(urllib.parse.unquote('${FTP_PASSWORD}'))")

# Define local paths
LOCAL_OVERWORLD="/app/data/worlds/overworld"
LOCAL_NETHER="/app/data/worlds/nether"
LOCAL_END="/app/data/worlds/end"
OUTPUT_DIR="/app/web"

# Create local directories if they do not exist
echo "Creating local directories..." >> /var/log/cron.log
mkdir -p ${LOCAL_OVERWORLD} ${LOCAL_NETHER} ${LOCAL_END}

# Connect to FTP and download/sync folders
echo "Connecting to FTP and syncing folders..." >> /var/log/cron.log
lftp -u ${FTP_USERNAME},${DECODED_FTP_PASSWORD} ${FTP_HOST} <<EOF
set ssl:verify-certificate no
mirror --verbose --continue --use-cache --parallel=10 /${OVERWORLD} ${LOCAL_OVERWORLD}
mirror --verbose --continue --use-cache --parallel=10 /${NETHER} ${LOCAL_NETHER}
mirror --verbose --continue --use-cache --parallel=10 /${END} ${LOCAL_END}
bye
EOF

# Run the Minecraft Overviewer to generate the index.html
echo "Running Minecraft Overviewer..." >> /var/log/cron.log
overviewer --config=config/config.py --skip-players --genpoi

echo "Update completed at $(date)" >> /var/log/cron.log
