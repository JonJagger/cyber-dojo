#!/bin/bash

# after running this check the coverage in index.html

rm -rf ../../coverage/.resultset.json
testrb . 2>&1 | tee log.tmp
cp -R ../../coverage/* .
ruby ../perc.rb index.html languages | tee -a log.tmp
