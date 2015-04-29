#!/bin/bash

echo
echo "======$1======"

rm -rf ../../coverage/.resultset.json
../testrb . 2>&1 | tee log.tmp
cp -R ../../coverage/* .
ruby ../print_coverage_percent.rb index.html $1 | tee -a log.tmp
