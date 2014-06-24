#!/bin/bash

# after running this check the coverage in index.html

testrb . 2>&1 | tee log.tmp
cp -R ../../coverage/* .
ruby ../perc.rb index.html app/lib | tee -a log.tmp
