FROM busybox
MAINTAINER Jon Jagger

ARG  CYBER_DOJO_ROOT

RUN mkdir -p ${CYBER_DOJO_ROOT}/languages
COPY       . ${CYBER_DOJO_ROOT}/languages
VOLUME     ["${CYBER_DOJO_ROOT}/languages"]

CMD ["not runnable - a data container"]
