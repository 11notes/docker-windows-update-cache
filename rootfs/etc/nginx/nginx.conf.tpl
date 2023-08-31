worker_processes auto;
worker_cpu_affinity auto;
worker_rlimit_nofile 204800;
error_log /var/log/nginx/error.log warn;

events {
  worker_connections 1024;
  use epoll;
  multi_accept on;
}

stream {
  resolver 9.9.9.9 8.8.8.8 ipv6=off;
  log_format stream escape=json '{"log":"tcp:proxy","time":"$time_iso8601", "server":{"name":"$upstream", "protocol":"$protocol"}, "client":{"ip":"$remote_addr"}, request:{"status":$status}, "cache":{"status":"MISS"}, "io":{"received":"$upstream_bytes_received", "sent":"$bytes_sent"}}}';
  access_log /var/log/nginx/access.log stream;

  map $ssl_preread_server_name $upstream{
    ~*.*download.windowsupdate.com$ "${ssl_preread_server_name}:443";
    ~*.*tlu.dl.delivery.mp.microsoft.com$ "${ssl_preread_server_name}:443";
    ~*.*officecdn.microsoft.com.edgesuite.net$ "${ssl_preread_server_name}:443";
    ~*.*officecdn.microsoft.com$ "${ssl_preread_server_name}:443";
    ~*.*windowsupdate.microsoft.com$ "${ssl_preread_server_name}:443";
    ~*.*windowsupdate.com$ "${ssl_preread_server_name}:443";
    ~*.*wustat.windows.com$ "${ssl_preread_server_name}:443";
    ~*.*ntservicepack.microsoft.com$ "${ssl_preread_server_name}:443";
    ~*.*forefrontdl.microsoft.com$ "${ssl_preread_server_name}:443";
    ~*.*update.microsoft.com$ "${ssl_preread_server_name}:443";
    ~*.*update.microsoft.com.nsatc.net$ "${ssl_preread_server_name}:443";
    ~*.*go.microsoft.com$ "${ssl_preread_server_name}:443";
    ~*.*dl.delivery.mp.microsoft.com$ "${ssl_preread_server_name}:443";
    ~*.*delivery.mp.microsoft.com$ "${ssl_preread_server_name}:443";
    default $CACHE_ACCESS_DENIED;
  }

  server {
    listen 443;
    proxy_buffer_size 16k;
    ssl_preread on;
    proxy_pass $upstream;
  }
}

http {
  resolver 9.9.9.9 8.8.8.8 ipv6=off;
  log_format proxy escape=json '{"log":"http:proxy","time":"$time_iso8601","server":{"name":"$host", "protocol":"$server_protocol"}, "client":{"ip":"$remote_addr"},"request":{"method":"$request_method", "url":"$request_uri", "time":"$request_time", "status":$status} "cache":{"status":"MISS"}, "io":{"received":"$upstream_bytes_received", "sent":"$bytes_sent"}}';
  log_format cache escape=json '{"log":"cache","time":"$time_iso8601","server":{"name":"$host", "protocol":"$server_protocol"}, "client":{"ip":"$remote_addr"},"request":{"method":"$request_method", "url":"$request_uri", "time":"$request_time", "status":$status}, "cache":{"status":"$upstream_cache_status"}, "io":{"received":"$upstream_bytes_received", "sent":"$bytes_sent"}}';
  access_log off;

  include mime.types;
  default_type application/octet-stream;

  proxy_cache_path /nginx/www levels=1:2 keys_zone=cache:256m max_size=$CACHE_SIZE inactive=$CACHE_MAX_AGE use_temp_path=off;

  sendfile on;
  aio on;
  tcp_nopush on;
  tcp_nodelay on;
  gzip on;
  keepalive_timeout 60;
  keepalive_requests 512;
  client_max_body_size 32G;
  client_body_buffer_size 16M;
  server_names_hash_max_size 1024;

  map $http_user_agent $no_cache {
    ~(swupd_syncd) 1;
    default 0;
  }

  server {
    access_log /var/log/nginx/access.log proxy;
    listen 80 default_server;
    server_name _;

    location / {
      proxy_http_version 1.1;
      proxy_pass http://${host};
      proxy_pass_request_headers on;
      proxy_set_header Host $host;
    }
  }

  server {
    listen 8443 ssl http2 default_server;
    server_name _;

    ssl_certificate /nginx/ssl/cert.pem;
    ssl_certificate_key /nginx/ssl/key.pem;

    location / {
      return 403;
    }
  }

  server {
    listen 80;
    server_name officecdn.microsoft.com;
    return 301 http://officecdn.microsoft.com.edgesuite.net$request_uri;
  }


  server {
    access_log /var/log/nginx/access.log cache;
    listen 80;

    server_name tlu.dl.delivery.mp.microsoft.com *.tlu.dl.delivery.mp.microsoft.com
                download.windowsupdate.com *.download.windowsupdate.com;

    ignore_invalid_headers off;
    proxy_cache cache;
    proxy_cache_valid 200 206 $CACHE_MAX_AGE;
    proxy_no_cache $no_cache;
    proxy_cache_methods GET;
    slice 16M;
    proxy_cache_lock on;
    proxy_cache_lock_timeout 600s;
    proxy_cache_lock_age 600s;
    proxy_cache_key "$request_method|$uri|$slice_range";
    proxy_cache_use_stale updating;

    location / {
      proxy_http_version 1.1;
      proxy_pass http://${host};
      proxy_pass_request_headers on;
      proxy_set_header Host $host;
      proxy_set_header Range $slice_range;
      proxy_set_header Upgrade-Insecure-Requests "";
      proxy_ignore_headers X-Accel-Expires Expires Cache-Control Set-Cookie Vary;
      proxy_hide_header ETag;
    }
  }

  server {
    access_log /var/log/nginx/access.log cache;
    listen 80;

    server_name officecdn.microsoft.com.edgesuite.net;

    ignore_invalid_headers off;
    proxy_cache cache;
    proxy_cache_valid 200 206 $CACHE_MAX_AGE;
    proxy_no_cache $no_cache;
    proxy_cache_methods GET;
    slice 16M;
    proxy_cache_lock on;
    proxy_cache_lock_timeout 600s;
    proxy_cache_lock_age 600s;
    proxy_cache_key "$request_method|$host$uri|$slice_range";
    proxy_cache_use_stale updating;

    location / {
      proxy_http_version 1.1;
      proxy_pass http://${host};
      proxy_pass_request_headers on;
      proxy_set_header Host $host;
      proxy_set_header Range $slice_range;
      proxy_set_header Upgrade-Insecure-Requests "";
      proxy_ignore_headers X-Accel-Expires Expires Cache-Control Set-Cookie Vary;
      proxy_hide_header ETag;
    }
  }
}