# Minecraft Overviewer Docker Container for Unraid

Welcome! This project was created to simplify hosting Minecraft Overviewer in a Docker container on my Unraid server. It syncs with my friend's Minecraft server via FTP and re-renders the map regularly using [Minecraft Overviewer](https://github.com/GregoryAM-SP/The-Minecraft-Overviewer).

## Configuration

Here's what you need to set up:

### Environment Variables

| Name            | Description                  |
|-----------------|------------------------------|
| `FTP_HOST`      | FTP Host                     |
| `FTP_USERNAME`  | FTP Username                 |
| `FTP_PASSWORD`  | URL encoded FTP Password     |
| `UPDATE_SCHEDULE` | Cron schedule for updates (syncs files and runs minecraft overviewer)  |
| `WEB_PORT`      | Port for web server          |
| `OVERWORLD`     | Name of the overworld directory |
| `NETHER`        | Name of the nether directory |
| `END`           | Name of the end directory    |
| `MC_VERSION`    | Minecraft version            |

### Volumes

| Name          | Container Path   | Description                              |
|---------------|------------------|------------------------------------------|
| `world data`  | `/app/data`      | Path to store Minecraft world data       |
| `web data`    | `/app/web/`      | Path to store web data                   |
| `config`      | `/app/config`    | Path to store configuration files        |

### Ports

| Name        | Container Port | Description              |
|-------------|----------------|--------------------------|
| `Host Port` | `8000`         | Port for the web server  |

---

I hope this makes setting up Minecraft Overviewer on your server easy and enjoyable!