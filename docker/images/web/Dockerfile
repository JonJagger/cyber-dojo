FROM rails:4.1
MAINTAINER Jon Jagger <jon@jaggersoft.com>

ARG              CYBER_DOJO_ROOT

RUN mkdir -p   ${CYBER_DOJO_ROOT}
COPY Gemfile   ${CYBER_DOJO_ROOT}
WORKDIR        ${CYBER_DOJO_ROOT}
RUN bundle install --without development test
EXPOSE 3000

COPY script    ${CYBER_DOJO_ROOT}/script
COPY config.ru ${CYBER_DOJO_ROOT}

RUN mkdir      ${CYBER_DOJO_ROOT}/caches
RUN mkdir      ${CYBER_DOJO_ROOT}/log
RUN mkdir      ${CYBER_DOJO_ROOT}/tmp

COPY exercises ${CYBER_DOJO_ROOT}/exercises
COPY languages ${CYBER_DOJO_ROOT}/languages

COPY test      ${CYBER_DOJO_ROOT}/test
COPY app       ${CYBER_DOJO_ROOT}/app
COPY config    ${CYBER_DOJO_ROOT}/config
COPY lib       ${CYBER_DOJO_ROOT}/lib

CMD [ "bash", "-c", "rails server" ]
