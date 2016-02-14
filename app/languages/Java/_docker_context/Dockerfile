
FROM       cyberdojofoundation/build-essential
MAINTAINER Luca B <blmlcu [at] gmail {dot} org>

RUN apt-get -y --force-yes -qq install wget

# Download Oracle Java from command line:
# http://stackoverflow.com/questions/10268583/how-to-automate-download-and-installation-of-java-jdk-on-linux/10959815#10959815
RUN [ \
  "wget", \
  "-O", "/tmp/jdk-8-linux-x64.tar.gz", \
  "--no-check-certificate", \
  "--no-cookies", \
  "--header", "Cookie: oraclelicense=accept-securebackup-cookie", \
  "http://download.oracle.com/otn-pub/java/jdk/8-b132/jdk-8-linux-x64.tar.gz" \
]

# Install Java 1.8
# http://install-things.com/2014/03/24/how-to-install-oracle-java-8-on-ubuntu-13-10-linux/
RUN ["mkdir", "-p", "/usr/lib/jvm"]

RUN ["tar", "xvf", "/tmp/jdk-8-linux-x64.tar.gz", "-C", "/usr/lib/jvm"]

RUN ["rm", "/tmp/jdk-8-linux-x64.tar.gz"]

RUN ["update-alternatives", "--install", "/usr/bin/javac", "javac", "/usr/lib/jvm/jdk1.8.0/bin/javac", "1"]
RUN ["update-alternatives", "--install", "/usr/bin/java", "java", "/usr/lib/jvm/jdk1.8.0/bin/java", "1"]

RUN ["update-alternatives", "--set", "javac", "/usr/lib/jvm/jdk1.8.0/bin/javac"]
RUN ["update-alternatives", "--set", "java", "/usr/lib/jvm/jdk1.8.0/bin/java"]
