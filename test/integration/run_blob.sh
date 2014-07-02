#!/bin/bash

# after running this check the coverage in index.html

cat test*.rb > all_tests_in_a_blob.rb
chmod +x all_tests_in_a_blob.rb
testrb ./all_tests_in_a_blob.rb
rm all_tests_in_a_blob.rb

cp -R ../../coverage/* .
ruby ../perc.rb index.html integration | tee -a log.tmp
