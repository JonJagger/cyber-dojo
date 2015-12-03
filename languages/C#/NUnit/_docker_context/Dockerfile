FROM       cyberdojofoundation/csharp-2.10.8.1
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN apt-get update && apt-get install -y \
  monodevelop-nunit \
  nunit-console

# After much searching I came across this
#   https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=638337
# which hinted at the reason NUnit did not run when the
# Docker user was www-data, and not root. (see lib/docker_runner.rb)
# The reason was that user www-data did not have HOME !!!
# and was defaulting to / which didn't have rights.

RUN usermod -m -d /home/www-data www-data
RUN mkdir /home/www-data
RUN chgrp www-data /home/www-data
RUN chown www-data /home/www-data
ENV HOME /home/www-data
