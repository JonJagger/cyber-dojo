#!/bin/bash

# after running this check the coverage in index.html

rm ../../coverage/.resultset.json
testrb . 2>&1 | tee log.tmp
cp -R ../../coverage/* .
ruby ../perc.rb index.html integration | tee -a log.tmp
