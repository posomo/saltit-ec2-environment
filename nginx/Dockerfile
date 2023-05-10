FROM openresty/openresty:alpine-fat

RUN apk update && apk upgrade && \
    apk add --no-cache bash git && \
    rm -rf /var/cache/apk/*

RUN /usr/local/openresty/luajit/bin/luarocks install lua-resty-lock

# Lua script 파일을 복사한다.
COPY script/generate_transaction_id.lua /etc/nginx/script/generate_transaction_id.lua
COPY script/init.lua /etc/nginx/script/init.lua

RUN luarocks install lua-resty-lock

# Nginx를 실행한다.
CMD ["nginx", "-g", "daemon off;"]