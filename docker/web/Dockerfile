FROM rails:4.1
MAINTAINER Jon Jagger <jon@jaggersoft.com>

ARG              CYBER_DOJO_ROOT

# install gems first as they change least and take longest
RUN mkdir -p   ${CYBER_DOJO_ROOT}
COPY Gemfile   ${CYBER_DOJO_ROOT}
WORKDIR        ${CYBER_DOJO_ROOT}
RUN bundle install --without development test
EXPOSE 3000

# install docker-client (see docker/readme.txt)
RUN curl -O https://get.docker.com/builds/Linux/x86_64/docker-latest && mv docker-latest /usr/bin/docker
RUN chmod +x /usr/bin/docker

# now install cyber-dojo
COPY script    ${CYBER_DOJO_ROOT}/script
COPY config.ru ${CYBER_DOJO_ROOT}

ENV EMPTY_DIRS ${CYBER_DOJO_ROOT}/caches \
               ${CYBER_DOJO_ROOT}/log \
               ${CYBER_DOJO_ROOT}/tmp

RUN mkdir $EMPTY_DIRS

COPY exercises ${CYBER_DOJO_ROOT}/exercises
COPY languages ${CYBER_DOJO_ROOT}/languages
COPY config    ${CYBER_DOJO_ROOT}/config
COPY test      ${CYBER_DOJO_ROOT}/test
COPY app       ${CYBER_DOJO_ROOT}/app
COPY lib       ${CYBER_DOJO_ROOT}/lib

CMD [ "bash", "-c", "rails server" ]
