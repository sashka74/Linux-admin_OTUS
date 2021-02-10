FROM alpine:latest
RUN apk update && apk add nginx && apk add openrc\
&& rc-update add nginx default && mkdir /run/nginx \
&& adduser -D -g 'www' www && mkdir /www \
&& chown -R www:www /var/lib/nginx && chown -R www:www /www \
&& mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig 
COPY nginx.conf /etc/nginx/
COPY index.html /www/index.html
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
