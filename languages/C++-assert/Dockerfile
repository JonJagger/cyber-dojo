FROM       cyberdojo/build-essential
MAINTAINER Jon Jagger <jon@jaggersoft.com>

ADD https://raw.githubusercontent.com/JonJagger/cyberdojo/master/languages/C++-assert/cyber-dojo.sh      /var/www/cyberdojo/languages/C++-assert/
ADD https://raw.githubusercontent.com/JonJagger/cyberdojo/master/languages/C++-assert/makefile           /var/www/cyberdojo/languages/C++-assert/
ADD https://raw.githubusercontent.com/JonJagger/cyberdojo/master/languages/C++-assert/manifest.json      /var/www/cyberdojo/languages/C++-assert/
ADD https://raw.githubusercontent.com/JonJagger/cyberdojo/master/languages/C++-assert/untitled.cpp       /var/www/cyberdojo/languages/C++-assert/
ADD https://raw.githubusercontent.com/JonJagger/cyberdojo/master/languages/C++-assert/untitled.hpp       /var/www/cyberdojo/languages/C++-assert/
ADD https://raw.githubusercontent.com/JonJagger/cyberdojo/master/languages/C++-assert/untitled.tests.cpp /var/www/cyberdojo/languages/C++-assert/

RUN chmod +r /var/www/cyberdojo/languages/C++-assert/*
RUN chmod +x /var/www/cyberdojo/languages/C++-assert/cyber-dojo.sh

# docker build -t  cyberdojo/language_gpp-4.8.1_assert .
# docker push      cyberdojo/language_gpp-4.8.1_assert
# docker run -i -t cyberdojo/language_gpp-4.8.1_assert /bin/bash
