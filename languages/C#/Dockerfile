FROM       cyberdojofoundation/build-essential
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# Fake a fuse install
RUN apt-get update && apt-get install --yes --force-yes libfuse2
RUN cd /tmp ; apt-get download fuse
RUN cd /tmp ; dpkg-deb -x fuse_* .
RUN cd /tmp ; dpkg-deb -e fuse_*
RUN cd /tmp ; rm fuse_*.deb
RUN cd /tmp ; echo -en '#!/bin/bash\nexit 0\n' > DEBIAN/postinst
RUN cd /tmp ; dpkg-deb -b . /fuse.deb
RUN cd /tmp ; dpkg -i /fuse.deb

RUN apt-get update && apt-get install --yes monodevelop

