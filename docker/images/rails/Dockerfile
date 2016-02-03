FROM rails:4.1
MAINTAINER Jon Jagger <jon@jaggersoft.com>

ARG  CYBER_DOJO_ROOT

RUN mkdir -p ${CYBER_DOJO_ROOT}
COPY Gemfile ${CYBER_DOJO_ROOT}
WORKDIR      ${CYBER_DOJO_ROOT}
RUN bundle install --without development test
EXPOSE 3000
