FROM       cyberdojofoundation/csharp-2.10.8.1_nunit
MAINTAINER Seb Rose <seb@claysnow.co.uk>

RUN apt-get update && apt-get -y install \
  wget \
  unzip

RUN wget https://github.com/downloads/techtalk/SpecFlow/SpecFlow_v1.9.0_bin.zip
RUN unzip SpecFlow_v1.9.0_bin.zip
WORKDIR tools
RUN gacutil -i Gherkin.dll -package SpecFlow
RUN gacutil -i IKVM.OpenJDK.Core.dll -package SpecFlow
RUN gacutil -i IKVM.OpenJDK.Security.dll -package SpecFlow
RUN gacutil -i IKVM.OpenJDK.Text.dll -package SpecFlow
RUN gacutil -i IKVM.OpenJDK.Util.dll -package SpecFlow
RUN gacutil -i IKVM.Runtime.dll -package SpecFlow
RUN gacutil -i TechTalk.SpecFlow.dll -package SpecFlow
RUN gacutil -i TechTalk.SpecFlow.Generator.dll -package SpecFlow
RUN gacutil -i TechTalk.SpecFlow.Parser.dll -package SpecFlow
RUN gacutil -i TechTalk.SpecFlow.Reporting.dll -package SpecFlow
RUN gacutil -i TechTalk.SpecFlow.Utils.dll  -package SpecFlow
WORKDIR ..

COPY /specflow.exe /specflow/

