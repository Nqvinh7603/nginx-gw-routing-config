#!/bin/sh

# 1. BE
## Build BE image
docker build -t c01-be ./be

## Run BE
docker run -d --name c01-be -p 8080:8080 c01-be

## Test BE
docker ps
curl http://localhost:8080/api


# 2. FE
## Build FE image
docker build -t c01-fe ./fe

## Run FE
docker run -d --name c01-fe -p 8000:8000 c01-fe

## Test FE
docker ps
curl http://localhost:8000/


# 3. Proxy
## 3.1. Install Nginx

## 3.2. Start nginx
sudo nginx

## 3.3. Edit nginx config file
## Linux: `/etc/nginx/nginx.conf`

```
server {
        listen       8001;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location /api {
            proxy_pass http://localhost:8080/api;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        location / {
            proxy_pass http://localhost:8000/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

}
```

## 3.4. Reload config
sudo nginx -s reload

## 3.5. Test
curl http://localhost:8001/
curl http://localhost:8001/api
