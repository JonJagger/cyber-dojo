FROM cyberdojofoundation/user-base
MAINTAINER Jon Jagger <jon@jaggersoft.com>

ARG CYBER_DOJO_HOME
ARG CYBER_DOJO_LOG=${CYBER_DOJO_HOME}/log

USER root
RUN  mkdir -p ${CYBER_DOJO_LOG}
RUN  chown -R cyber-dojo ${CYBER_DOJO_LOG}
VOLUME [ "${CYBER_DOJO_LOG}" ]
CMD [ "rails-log-data-container" ]
