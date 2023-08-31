# Alpine :: Microsoft Update Cache
Run a Microsoft Update Cache server based on Alpine Linux. Small, lightweight, secure and fast 🏔️

## Efficiency
All logs are in JSON format. You can send them to a Redis server via docker Redis log plugin and parse bytes sent and received as well as cache status to determine how much data was served from cache and how much was downloaded from WAN. CACHE_ACCESS_DENIED is used to block someone from using the proxy as a regular web proxy. Only FQDN in the nginx.conf are allowed to WAN, anything else will be redirect to CACHE_ACCESS_DENIED.


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

## Parent
* [11notes/nginx:stable](https://github.com/11notes/docker-nginx)

## Built with
* [nginx_lancache](https://github.com/tsvcathed/nginx_lancache)
* [Alpine Linux](https://alpinelinux.org/)

## Tips
* Don't bind to ports < 1024 (requires root), use NAT/reverse proxy
* [Persistent Storage Plugin](https://github.com/11notes/alpine-docker-netshare)