#!/bin/bash

echo
rm -rf log.tmp
rm -rf cated.tmp
modules=( test*.rb )
for module in ${modules[@]}
do
    echo $module
    ruby $module > log.tmp
    egrep 'Finished tests' log.tmp
    cat log.tmp >> cated.tmp
done

egrep 'assertions,' cated.tmp
