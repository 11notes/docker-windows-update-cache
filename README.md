![Banner](https://github.com/11notes/defaults/blob/main/static/img/banner.png?raw=true)

# 🏔️ Alpine - Windows Update Cache
![size](https://img.shields.io/docker/image-size/11notes/windows-update-cache/1.1.0?color=0eb305) ![version](https://img.shields.io/docker/v/11notes/windows-update-cache/1.1.0?color=eb7a09) ![pulls](https://img.shields.io/docker/pulls/11notes/windows-update-cache?color=2b75d6) ![stars](https://img.shields.io/docker/stars/11notes/windows-update-cache?color=e6a50e) [<img src="https://img.shields.io/badge/github-11notes-blue?logo=github">](https://github.com/11notes)

**Cache Windows Update for all clients via Nginx**

# SYNOPSIS
What can I do with this? This image will run Nginx as a cache proxy for all Windows Update of all your clients. This means an update is downloaded only once from the web and then stored in the cache. Any further request for this update will be served from the local cache, preserving WAN bandwidth.

# VOLUMES
* **/nginx/www** - Directory of all updates

# COMPOSE
```yaml
services:
  windows-update-cache:
    image: "11notes/windows-update-cache:1.1.0"
    container_name: "windows-update-cache"
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - "www:/nginx/www"
    sysctls:
      - net.ipv4.ip_unprivileged_port_start=80
volumes:
  www:
```

# DEFAULT SETTINGS
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user docker |
| `uid` | 1000 | user id 1000 |
| `gid` | 1000 | group id 1000 |
| `home` | /nginx | home directory of user docker |

# ENVIRONMENT
| Parameter | Value | Default |
| --- | --- | --- |
| `TZ` | [Time Zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) | |
| `DEBUG` | Show debug information | |
| `CACHE_SIZE` | size of cache | 256g |
| `CACHE_MAX_AGE` | how long data should be cached | 14d |
| `CACHE_ACCESS_DENIED` | domain.com:443, FQDN:port to inform about access denied | 127.0.0.1:8443 |

# PARENT IMAGE
* [11notes/nginx:stable](https://hub.docker.com/r/11notes/nginx)

# BUILT WITH
* [nginx_lancache](https://github.com/tsvcathed/nginx_lancache)
* [alpine](https://alpinelinux.org)

# TIPS
* Allow non-root ports < 1024 via `echo "net.ipv4.ip_unprivileged_port_start={n}" > /etc/sysctl.d/ports.conf`
* Use a reverse proxy like Traefik, Nginx to terminate TLS with a valid certificate
* Use Let’s Encrypt certificates to protect your SSL endpoints

# ElevenNotes<sup>™️</sup>
This image is provided to you at your own risk. Always make backups before updating an image to a new version. Check the changelog for breaking changes. You can find all my repositories on [github](https://github.com/11notes).
    