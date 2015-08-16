FROM       cyberdojo/fsharp-3.0
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN mono nuget.exe install NUnit.Runners -o Packages -ExcludeVersion

RUN mkdir /resources
ADD nunit.framework.dll /resources/
ENV MONO_PATH=/resources/

