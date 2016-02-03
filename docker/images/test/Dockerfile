FROM busybox
MAINTAINER Jon Jagger

ARG  CYBER_DOJO_ROOT

RUN mkdir -p ${CYBER_DOJO_ROOT}/test
COPY       . ${CYBER_DOJO_ROOT}/test
VOLUME     ["${CYBER_DOJO_ROOT}/test"]

CMD ["not runnable - a data container"]
