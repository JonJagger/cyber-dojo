FROM busybox
MAINTAINER Jon Jagger <jon@jaggersoft.com>

ARG               CYBER_DOJO_ROOT
ARG               DIR=${CYBER_DOJO_ROOT}/languages
RUN mkdir -p    ${DIR}
COPY .          ${DIR}
RUN chmod -R +r ${DIR}
VOLUME        ["${DIR}"]

CMD ["not runnable - a data container"]
