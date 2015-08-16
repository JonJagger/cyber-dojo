FROM       cyberdojo/fsharp-3.0
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN mono nuget.exe install NUnit.Runners -o Packages -ExcludeVersion

RUN mkdir /nunit
ADD nunit.framework.dll /nunit/
#ENV MONO_PATH=/nunit/
RUN gacutil -i /nunit/nunit.framework.dll -package nunit

