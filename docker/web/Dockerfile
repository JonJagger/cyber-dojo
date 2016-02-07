# Based on http://blog.kontena.io/building-minimal-docker-image-for-rails/
FROM alpine:3.2
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# - - - - - - - - - - - - - - - - - - - - - -
# install docker-client (see docker/docker-from-docker-readme.txt)
# install ruby, ruby-bigdecimal, tzdata (for rails server)
# install git and acl (for cyber-dojo)

RUN    apk --update add curl \
    && curl -O https://get.docker.com/builds/Linux/x86_64/docker-latest \
    && mv docker-latest /usr/bin/docker \
    && chmod +x /usr/bin/docker \
    && apk del curl \
    && apk --update add \
          ruby ruby-bigdecimal tzdata \
          git acl

ARG CYBER_DOJO_ROOT

# - - - - - - - - - - - - - - - - - - - - - -
# bundle install from cyber-dojo's Gemfile

RUN  mkdir -p     ${CYBER_DOJO_ROOT}
COPY Gemfile      ${CYBER_DOJO_ROOT}
RUN apk --update add --virtual build-dependencies \
      build-base \
      ruby-dev \
      openssl-dev \
      postgresql-dev \
      libc-dev \
      linux-headers \
    && gem install bundler --no-ri --no-rdoc \
    && cd ${CYBER_DOJO_ROOT} ; bundle install --without development test \
    && apk del build-dependencies

# - - - - - - - - - - - - - - - - - - - - - -
# copy cyber-dojo rails app

COPY . ${CYBER_DOJO_ROOT}
ENV EMPTY_DIRS \
    ${CYBER_DOJO_ROOT}/caches \
    ${CYBER_DOJO_ROOT}/log \
    ${CYBER_DOJO_ROOT}/tmp
RUN mkdir $EMPTY_DIRS
WORKDIR ${CYBER_DOJO_ROOT}

EXPOSE 3000

RUN deluser xfs
RUN adduser -G www-data -D -H -u 33 www-data

CMD [ "bash", "-c", "rails server" ]
