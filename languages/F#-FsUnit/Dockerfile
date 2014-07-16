FROM       cyberdojo/fsharp-3.0.26-1
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN apt-get install -y monodevelop-nunit

RUN mono nuget.exe install NUnit.Runners -o Packages
RUN mono nuget.exe install FsUnit -o Packages

