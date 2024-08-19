# :: Util
  FROM alpine as util

  RUN set -ex; \
    apk add --no-cache \
      git; \
    git clone https://github.com/11notes/util.git;

# :: Header
  FROM 11notes/nginx:stable
  COPY --from=util /util/linux/shell/elevenLogJSON /usr/local/bin
  ENV APP_ROOT=/nginx
  ENV APP_NAME="windows-update-cache"

# :: Run
  USER root

  # :: prepare image
    RUN set -ex; \
      apk add --no-cache \
        openssl; \
      apk --no-cache upgrade; \
      rm -rf /etc/nginx/nginx.conf; \
      rm -rf /nginx/etc/default.conf;

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