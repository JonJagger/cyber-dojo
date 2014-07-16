FROM       cyberdojo/fsharp-3.0.26-1
MAINTAINER Jon Jagger <jon@jaggersoft.com>

#RUN mono nuget.exe install NUnit  -o Packages -ExcludeVersion

RUN mono nuget.exe install NUnit.Runners -o Packages -ExcludeVersion
RUN mono nuget.exe install FsUnit -o Packages -ExcludeVersion

RUN gacutil -i /Packages/NUnit.Runners/tools/nunit.framework.dll
RUN gacutil -i /Packages/FsUnit/Lib/Net40/FsUnit.NUnit.dll
