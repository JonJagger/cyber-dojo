#!/bin/bash

# TODO: On blog
#  say install docker using http:get.docker.com
#TODO: ./cyber-dojo pull gcc_assert
#TODO: ./cyber-dojo pull java_junit
#TODO: ./cyber-dojo pull csharp_nunit


# TODO: FILE=installing-more-languages-readme.txt ?

#BRANCH=$1
#OS=$2
# TODO: validate $1

FILE=docker-compose.yml
curl -O ${BRANCH}/${FILE}


#SCRIPT=docker-pull-common-languages.sh
#curl -O ${BRANCH}/${SCRIPT}
#chmod +x ${SCRIPT}
#./${SCRIPT}



#SCRIPT=cyber-dojo-up.sh
#curl -O ${BRANCH}/${SCRIPT}
#chmod +x ${SCRIPT}

# Put info on making this call on the blog page
#./${SCRIPT} --katas=....