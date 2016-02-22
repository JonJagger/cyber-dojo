FROM cyberdojofoundation/user-base
MAINTAINER Jon Jagger <jon@jaggersoft.com>

ARG CYBER_DOJO_HOME
ARG CYBER_DOJO_EXERCISES_ROOT=${CYBER_DOJO_HOME}/app/exercises

USER root
RUN  mkdir ${CYBER_DOJO_EXERCISES_ROOT}
COPY . ${CYBER_DOJO_EXERCISES_ROOT}
RUN  chown -R cyber-dojo ${CYBER_DOJO_EXERCISES_ROOT}

USER cyber-dojo
