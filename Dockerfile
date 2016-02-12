# Based on http://blog.kontena.io/building-minimal-docker-image-for-rails/
FROM alpine:3.2
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# - - - - - - - - - - - - - - - - - - - - - -
# install docker-client (see docker/docker-from-docker-readme.txt)
# install ruby, ruby-bigdecimal, tzdata (for rails server)
# install git (for cyber-dojo)

RUN    apk --update add curl \
    && curl -O https://get.docker.com/builds/Linux/x86_64/docker-latest \
    && mv docker-latest /usr/bin/docker \
    && chmod +x /usr/bin/docker \
    && apk del curl \
    && apk --update add \
          ruby \
          ruby-bigdecimal \
          tzdata \
          git

ARG CYBER_DOJO_HOME

# - - - - - - - - - - - - - - - - - - - - - -
# bundle install from cyber-dojo's Gemfile

RUN  mkdir -p     ${CYBER_DOJO_HOME}
COPY Gemfile      ${CYBER_DOJO_HOME}
RUN apk --update add --virtual build-dependencies \
      build-base \
      ruby-dev \
      openssl-dev \
      postgresql-dev \
      libc-dev \
      linux-headers \
    && gem install bundler --no-ri --no-rdoc \
    && cd ${CYBER_DOJO_HOME} ; bundle install --without development test \
    && apk del build-dependencies

# - - - - - - - - - - - - - - - - - - - - - -
# copy cyber-dojo rails app

COPY . ${CYBER_DOJO_HOME}
RUN mkdir \
    ${CYBER_DOJO_HOME}/caches \
    ${CYBER_DOJO_HOME}/log \
    ${CYBER_DOJO_HOME}/tmp

WORKDIR ${CYBER_DOJO_HOME}

EXPOSE 3000

CMD [ "bash", "-c", "rails server" ]
