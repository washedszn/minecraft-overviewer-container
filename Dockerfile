# Use a base image with Python and necessary tools
FROM python:3.9-slim

# Install necessary packages
RUN apt-get update && \
    apt-get install -y lftp cron wget xz-utils jq && \
    apt-get clean

# Set the working directory
WORKDIR /app

# Download and install Minecraft Overviewer
RUN wget https://github.com/GregoryAM-SP/The-Minecraft-Overviewer/releases/download/1.21.0/overviewer-v1.21.0-LINUX.tar.xz && \
    tar -xf overviewer-v1.21.0-LINUX.tar.xz && \
    mv overviewer/* /usr/local/bin/ && \
    rm -rf overviewer overviewer-v1.21.0-LINUX.tar.xz

# Copy the application files
COPY . .

# Expose the web port
EXPOSE ${WEB_PORT}

# Copy the entrypoint script
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Start the entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["python3", "-m", "http.server", "${WEB_PORT}", "--directory", "/app/web"]
