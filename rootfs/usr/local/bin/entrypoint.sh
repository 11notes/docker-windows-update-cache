#!/bin/ash
  if [ -z "$1" ]; then
    if [ -z "${CACHE_SIZE}" ]; then CACHE_SIZE=256g; fi 
    if [ -z "${CACHE_MAX_AGE}" ]; then CACHE_MAX_AGE=14d; fi
    if [ -z "${CACHE_ACCESS_DENIED}" ]; then CACHE_MAX_AGE=127.0.0.1:8443; fi

    openssl req -x509 -newkey rsa:4096 -subj "/C=XX/ST=XX/L=XX/O=XX/OU=XX/CN=XX" \
      -keyout "/nginx/ssl/key.pem" \
      -out "/nginx/ssl/cert.pem" \
      -days 3650 -nodes -sha256 &> /dev/null

    cp /etc/nginx/nginx.conf.tpl /etc/nginx/nginx.conf
    sed -i "s/\$CACHE_SIZE/${CACHE_SIZE}/g" /etc/nginx/nginx.conf
    sed -i "s/\$CACHE_MAX_AGE/${CACHE_MAX_AGE}/g" /etc/nginx/nginx.conf
    sed -i "s/\$CACHE_ACCESS_DENIED/${CACHE_ACCESS_DENIED}/g" /etc/nginx/nginx.conf

    set -- "nginx" \
      -g \
      'daemon off;'
  fi

  exec "$@"