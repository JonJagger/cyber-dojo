FROM cyberdojofoundation/user-base
MAINTAINER Jon Jagger <jon@jaggersoft.com>

ARG CYBER_DOJO_HOME
ARG CYBER_DOJO_LANGUAGES_ROOT=${CYBER_DOJO_HOME}/app/languages

USER root
RUN  mkdir ${CYBER_DOJO_LANGUAGES_ROOT}
COPY . ${CYBER_DOJO_LANGUAGES_ROOT}
RUN  chown -R cyber-dojo ${CYBER_DOJO_LANGUAGES_ROOT}

USER cyber-dojo
