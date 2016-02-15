FROM nginx:1.9
MAINTAINER Jon Jagger <jon@jaggersoft.com>

ARG NGINX_DIR=/usr/share/nginx/html

RUN      rm -rf ${NGINX_DIR}
COPY     .      ${NGINX_DIR}
RUN chmod -R +r ${NGINX_DIR}

COPY nginx.conf /etc/nginx/conf.d/default.conf
