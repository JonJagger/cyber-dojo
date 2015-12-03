FROM       cyberdojofoundation/java-1.8
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN apt-get update && apt-get install --yes \
  wget \
  unzip

RUN wget http://dl.bintray.com/groovy/maven/apache-groovy-binary-2.4.4.zip
RUN unzip apache-groovy-binary-2.4.4.zip

ENV GROOVY_HOME=/groovy-2.4.4
ENV PATH=$GROOVY_HOME/bin:$PATH

