FROM cyberdojofoundation/user-base
MAINTAINER Jon Jagger <jon@jaggersoft.com>

ARG CYBER_DOJO_HOME

USER root
RUN  mkdir -p ${CYBER_DOJO_HOME}
COPY . ${CYBER_DOJO_HOME}
RUN  chown -R cyber-dojo ${CYBER_DOJO_HOME}

# In the docker-compose.yml file the rails-app is volumes-from:
# mounted as :ro (read-only). It's important therefore not to
# create a VOLUME for ${CYBER_DOJO_HOME} as that will prevent
# sub-folders of ${CYBER_DOJO_HOME} from being mounted volumes-from: rw

VOLUME [ "${CYBER_DOJO_HOME}/app/assets" ]
VOLUME [ "${CYBER_DOJO_HOME}/app/controllers" ]
VOLUME [ "${CYBER_DOJO_HOME}/app/helpers" ]
VOLUME [ "${CYBER_DOJO_HOME}/app/lib" ]
VOLUME [ "${CYBER_DOJO_HOME}/app/models" ]
VOLUME [ "${CYBER_DOJO_HOME}/app/views" ]
VOLUME [ "${CYBER_DOJO_HOME}/script" ]
VOLUME [ "${CYBER_DOJO_HOME}/config" ]
VOLUME [ "${CYBER_DOJO_HOME}/lib" ]

CMD [ "rails-app-data-container" ]
