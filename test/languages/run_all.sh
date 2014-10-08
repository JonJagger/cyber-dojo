#!/bin/bash

# after running this check the coverage in index.html

rm -rf ../../coverage/.resultset.json
testrb . 2>&1 | tee log.tmp
cp -R ../../coverage/* .
ruby ../print_coverage_percent.rb index.html languages | tee -a log.tmp
