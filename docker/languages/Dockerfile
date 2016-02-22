FROM cyberdojofoundation/user-base
MAINTAINER Jon Jagger <jon@jaggersoft.com>

ARG CYBER_DOJO_LANGUAGES_ROOT

USER root
RUN  mkdir -p ${CYBER_DOJO_LANGUAGES_ROOT}
COPY . ${CYBER_DOJO_LANGUAGES_ROOT}
RUN  chown -R cyber-dojo ${CYBER_DOJO_LANGUAGES_ROOT}
VOLUME [ "${CYBER_DOJO_LANGUAGES_ROOT}" ]
CMD [ "katas-data-container" ]
