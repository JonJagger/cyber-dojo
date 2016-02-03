FROM busybox
MAINTAINER Jon Jagger

ARG  CYBER_DOJO_ROOT

RUN mkdir -p ${CYBER_DOJO_ROOT}/katas
COPY       . ${CYBER_DOJO_ROOT}/katas
VOLUME     ["${CYBER_DOJO_ROOT}/katas"]

CMD ["not runnable - a data container"]
