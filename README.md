# Alpine :: Microsoft Update Cache
![size](https://img.shields.io/docker/image-size/11notes/windows-update-cache/1.0.0?color=0eb305) ![version](https://img.shields.io/docker/v/11notes/windows-update-cache?color=eb7a09) ![pulls](https://img.shields.io/docker/pulls/11notes/windows-update-cache?color=2b75d6) ![activity](https://img.shields.io/github/commit-activity/m/11notes/docker-windows-update-cache?color=c91cb8) ![commit-last](https://img.shields.io/github/last-commit/11notes/docker-windows-update-cache?color=c91cb8)

Run a Microsoft Update Cache server based on Alpine Linux. Small, lightweight, secure and fast 🏔️

## Efficiency
All logs are in JSON format. You can send them to a Redis server via docker Redis log plugin and parse bytes sent and received as well as cache status to determine how much data was served from cache and how much was downloaded from WAN. CACHE_ACCESS_DENIED is used to block someone from using the proxy as a regular web proxy. Only FQDN in the nginx.conf are allowed to WAN, anything else will be redirect to CACHE_ACCESS_DENIED.

## DNS (windows-update-cache) example
```
  ...
  zone "download.windowsupdate.com" IN { type master; file "/windows-update-cache/var/windows-update-cache.db";  allow-update { none; }; };
  zone "tlu.dl.delivery.mp.microsoft.com" IN { type master; file "/windows-update-cache/var/windows-update-cache.db";  allow-update { none; }; };
  zone "officecdn.microsoft.com.edgesuite.net" IN { type master; file "/windows-update-cache/var/windows-update-cache.db";  allow-update { none; }; };
  zone "officecdn.microsoft.com" IN { type master; file "/windows-update-cache/var/windows-update-cache.db";  allow-update { none; }; };
  zone "windowsupdate.microsoft.com" IN { type master; file "/windows-update-cache/var/windows-update-cache.db";  allow-update { none; }; };
  zone "windowsupdate.com" IN { type master; file "/windows-update-cache/var/windows-update-cache.db";  allow-update { none; }; };
  zone "wustat.windows.com" IN { type master; file "/windows-update-cache/var/windows-update-cache.db";  allow-update { none; }; };
  zone "ntservicepack.microsoft.com" IN { type master; file "/windows-update-cache/var/windows-update-cache.db";  allow-update { none; }; };
  zone "forefrontdl.microsoft.com" IN { type master; file "/windows-update-cache/var/windows-update-cache.db";  allow-update { none; }; };
  zone "update.microsoft.com" IN { type master; file "/windows-update-cache/var/windows-update-cache.db";  allow-update { none; }; };
  zone "update.microsoft.com.nsatc.net" IN { type master; file "/windows-update-cache/var/windows-update-cache.db";  allow-update { none; }; };
  zone "go.microsoft.com" IN { type master; file "/windows-update-cache/var/windows-update-cache.db";  allow-update { none; }; };
  zone "dl.delivery.mp.microsoft.com" IN { type master; file "/windows-update-cache/var/windows-update-cache.db";  allow-update { none; }; };
  zone "delivery.mp.microsoft.com" IN { type master; file "/windows-update-cache/var/windows-update-cache.db";  allow-update { none; }; };
  ...

  
  /windows-update-cache/var/windows-update-cache.db
  @   IN    A   IP_OF_YOUR_CACHE_SERVER
  *   IN    A   IP_OF_YOUR_CACHE_SERVER
```


## Volumes
* **/nginx/www** - Directory of all cached data

## Run
```shell
docker run --name windows-update-cache \
  -v ../cache:/nginx/www \
  -d 11notes/windows-update-cache:[tag]
```

## Defaults
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user docker |
| `uid` | 1000 | user id 1000 |
| `gid` | 1000 | group id 1000 |
| `home` | /nginx | home directory of user docker |

## Environment
| Parameter | Value | Default |
| --- | --- | --- |
| `CACHE_SIZE` | size of cache | 256g |
| `CACHE_MAX_AGE` | how long data should be cached | 14d |
| `CACHE_ACCESS_DENIED` | domain.com:443, FQDN:port to inform about access denied | 127.0.0.1:8443 |

## Parent image
* [11notes/nginx:stable](https://github.com/11notes/docker-nginx)

## Built with and thanks to
* [Nnginx_lancache](https://github.com/tsvcathed/nginx_lancache)
* [Alpine Linux](https://alpinelinux.org/)

## Tips
* Only use rootless container runtime (podman, rootless docker)
* Don't windows-update-cache to ports < 1024 (requires root), use NAT/reverse proxy (haproxy, traefik, nginx)