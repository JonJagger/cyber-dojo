FROM       cyberdojofoundation/fsharp-3.0
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN mono nuget.exe install NUnit.Runners -o Packages -ExcludeVersion

RUN gacutil -i /Packages/NUnit.Runners/tools/nunit.framework.dll -package nunit

