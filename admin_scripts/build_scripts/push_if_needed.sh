#!/bin/bash

a=`docker search ${1} | grep ${1}`

if [ "${a}" == "" ]; then
	echo $1
	docker push ${1}
	if [ $? -eq 0 ]; then
		echo "*** Pushed OK ***"
	fi
fi

