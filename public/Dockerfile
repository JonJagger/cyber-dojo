FROM nginx:1.9
MAINTAINER Jon Jagger <jon@jaggersoft.com>

ARG DIR=/usr/share/nginx/html

RUN      rm -rf ${DIR}
COPY     .      ${DIR}
RUN chmod -R +r ${DIR}

COPY nginx.conf /etc/nginx/conf.d/default.conf
