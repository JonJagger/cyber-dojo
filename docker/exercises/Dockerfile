FROM cyberdojofoundation/user-base
MAINTAINER Jon Jagger <jon@jaggersoft.com>

ARG CYBER_DOJO_EXERCISES_ROOT

USER root
RUN  mkdir -p ${CYBER_DOJO_EXERCISES_ROOT}
COPY . ${CYBER_DOJO_EXERCISES_ROOT}
RUN  chown -R cyber-dojo ${CYBER_DOJO_EXERCISES_ROOT}
VOLUME [ "${CYBER_DOJO_EXERCISES_ROOT}" ]
CMD [ "exercises-data-container" ]
