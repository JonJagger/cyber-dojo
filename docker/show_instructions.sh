#!/bin/bash

OSES=(debian-jessie ubuntu-trusty)

echo '--------------------------------------------'
echo ': Do these steps once only'
echo ':'
echo ': o) install docker (using one of these)'
for OS in ${OSES[*]}
do
  echo ":   $ ./install-docker-on-${OS}.sh "
done
echo ':'
echo ': o) build your katas image'
echo ':   $ ./build-katas-image.sh'
echo ':'
echo '--------------------------------------------'
echo

# NB: if install is on top of old-style server I need
#     to update the old images if the new image (alpine based)
#     has the same name. This is also a once only operation.
#

# NB: Better to just install a common selection...
echo 'install the docker image for your chosen languages, eg'
echo '  $ docker pull cyberdojofoundation/gcc_assert'
echo '  $ docker pull cyberdojofoundation/java_junit'
echo '  $ docker pull cyberdojofoundation/csharp_nunit'
echo

echo bring up cyber-dojo
echo   $ ./cyber-dojo-up.sh
echo
