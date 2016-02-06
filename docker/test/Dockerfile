FROM busybox
MAINTAINER Jon Jagger <jon@jaggersoft.com>

ARG CYBER_DOJO_ROOT
ARG IMAGE=test
ARG DIR=${CYBER_DOJO_ROOT}/${IMAGE}

RUN mkdir -p    ${DIR}
COPY ${IMAGE}   ${DIR}
RUN chmod -R +r ${DIR}
VOLUME        ["${DIR}"]

CMD ["not runnable - a data container"]
