FROM busybox
MAINTAINER Jon Jagger

ARG  CYBER_DOJO_ROOT

RUN mkdir -p ${CYBER_DOJO_ROOT}/exercises
COPY       . ${CYBER_DOJO_ROOT}/exercises
VOLUME     ["${CYBER_DOJO_ROOT}/exercises"]

CMD ["not runnable - a data container"]
