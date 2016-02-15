FROM cyberdojofoundation/user-base
MAINTAINER Jon Jagger <jon@jaggersoft.com>

ARG CYBER_DOJO_KATAS_ROOT

RUN  mkdir -p     ${CYBER_DOJO_KATAS_ROOT}
COPY . ${CYBER_DOJO_KATAS_ROOT}
RUN chown -R cyber-dojo ${CYBER_DOJO_KATAS_ROOT}

VOLUME CYBER_DOJO_KATAS_ROOT

#ENTRYPOINT ["data-container"]
