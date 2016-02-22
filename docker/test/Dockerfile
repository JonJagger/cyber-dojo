FROM cyberdojofoundation/user-base
MAINTAINER Jon Jagger <jon@jaggersoft.com>

ARG CYBER_DOJO_TEST_ROOT

USER root
RUN  mkdir -p ${CYBER_DOJO_TEST_ROOT}
COPY . ${CYBER_DOJO_TEST_ROOT}
RUN  chown -R cyber-dojo ${CYBER_DOJO_TEST_ROOT}
VOLUME [ "${CYBER_DOJO_TEST_ROOT}" ]
CMD [ "test-data-container" ]
