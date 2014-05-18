#!/bin/bash

testrb . 2>&1 | tee log.tmp
cp -R ../../coverage/* .
ruby ../perc.rb index.html app/helpers | tee -a log.tmp
