FROM busybox
MAINTAINER Jon Jagger <jon@jaggersoft.com>

ARG            DIR=exercises
ARG            CYBER_DOJO_ROOT
RUN mkdir -p ${CYBER_DOJO_ROOT}/${DIR}
COPY .       ${CYBER_DOJO_ROOT}/${DIR}
VOLUME     ["${CYBER_DOJO_ROOT}/${DIR}"]

CMD ["not runnable - a data container"]
