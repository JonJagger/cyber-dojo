FROM cyberdojofoundation/user-base
MAINTAINER Jon Jagger <jon@jaggersoft.com>

ARG CYBER_DOJO_HOME
ARG CYBER_DOJO_TMP=${CYBER_DOJO_HOME}/tmp

USER root
RUN  mkdir -p ${CYBER_DOJO_TMP}
RUN  chown -R cyber-dojo ${CYBER_DOJO_TMP}
VOLUME [ "${CYBER_DOJO_TMP}" ]
CMD [ "rails-tmp-data-container" ]
