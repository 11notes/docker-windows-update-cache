# :: Header
  FROM 11notes/nginx:stable
  ENV APP_ROOT=/nginx

# :: Run
  USER root

  # :: update image
    RUN set -ex; \
      apk add --no-cache \
        openssl; \
      apk --no-cache upgrade;

  # :: copy root filesystem changes and set correct permissions
    COPY ./rootfs /
    RUN set -ex; \
      chmod +x -R /usr/local/bin; \
      chown -R 1000:1000 \
        /etc/nginx \
        ${APP_ROOT};

# :: Start
  USER docker
  ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]