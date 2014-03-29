FROM       cyberdojo/build-essential
MAINTAINER Jon Jagger <jon@jaggersoft.com>

ADD https://raw.githubusercontent.com/JonJagger/cyberdojo/master/languages/C/cyber-dojo.sh    /var/www/cyberdojo/katas/00/00000000/
ADD https://raw.githubusercontent.com/JonJagger/cyberdojo/master/languages/C/makefile         /var/www/cyberdojo/katas/00/00000000/
ADD https://raw.githubusercontent.com/JonJagger/cyberdojo/master/languages/C/manifest.json    /var/www/cyberdojo/katas/00/00000000/
ADD https://raw.githubusercontent.com/JonJagger/cyberdojo/master/languages/C/untitled.c       /var/www/cyberdojo/katas/00/00000000/
ADD https://raw.githubusercontent.com/JonJagger/cyberdojo/master/languages/C/untitled.h       /var/www/cyberdojo/katas/00/00000000/
ADD https://raw.githubusercontent.com/JonJagger/cyberdojo/master/languages/C/untitled.tests.c /var/www/cyberdojo/katas/00/00000000/

RUN chmod +r /var/www/cyberdojo/katas/00/00000000/*
RUN chmod +x /var/www/cyberdojo/katas/00/00000000/cyber-dojo.sh

# docker build -t  cyberdojo/language_gcc-4.8.1_assert .
# docker push      cyberdojo/language_gcc-4.8.1_assert
# docker run -i -t cyberdojo/language_gcc-4.8.1_assert /bin/bash
