FROM       cyberdojo/csharp-2.10.8.1
MAINTAINER Seb Rose <seb@claysnow.co.uk>

RUN apt-get install -y monodevelop-nunit
RUN apt-get install -y nunit-console

RUN apt-get -y install wget
RUN apt-get -y install unzip

RUN wget https://github.com/downloads/techtalk/SpecFlow/SpecFlow_v1.9.0_bin.zip
RUN unzip SpecFlow_v1.9.0_bin.zip
WORKDIR tools
RUN ls
RUN gacutil -i Gherkin.dll
RUN gacutil -i IKVM.OpenJdk.Core.dll
RUN gacutil -i IKVM.OpenJdk.Security.dll
RUN gacutil -i IKVM.OpenJdk.Text.dll
RUN gacutil -i IKVM.OpenJdk.Util.dll
RUN gacutil -i IKVM.Runtime.dll
RUN gacutil -i TechTalk.SpecFlow.dll
RUN gacutil -i TechTalk.SpecFlow.Generator.dll
RUN gacutil -i TechTalk.SpecFlow.Parser.dll
RUN gacutil -i TechTalk.SpecFlow.Reporting.dll
RUN gacutil -i TechTalk.SpecFlow.Utils.dll
