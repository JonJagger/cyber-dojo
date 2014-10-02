FROM       cyberdojo/csharp-2.10.8.1
MAINTAINER Seb Rose <seb@claysnow.co.uk>

RUN apt-get install -y monodevelop-nunit
RUN apt-get install -y nunit-console

RUN apt-get -y install wget
RUN apt-get -y install unzip

RUN wget https://github.com/downloads/techtalk/SpecFlow/SpecFlow_v1.9.0_bin.zip
RUN unzip SpecFlow_v1.9.0_bin.zip
RUN gacutil –i tools/Gherkin.dll
RUN gacutil –i tools/IKVM.OpenJDK.Core.dll
RUN gacutil –i tools/IKVM.OpenJDK.Security.dll
RUN gacutil –i tools/IKVM.OpenJDK.Text.dll
RUN gacutil –i tools/IKVM.OpenJDK.Util.dll
RUN gacutil –i tools/IKVM.Runtime.dll
RUN gacutil –i tools/TechTalk.SpecFlow.dll
RUN gacutil –i tools/TechTalk.SpecFlow.Generator.dll
RUN gacutil –i tools/TechTalk.SpecFlow.Parser.dll
RUN gacutil –i tools/TechTalk.SpecFlow.Reporting.dll
RUN gacutil –i tools/TechTalk.SpecFlow.Utils.dll
