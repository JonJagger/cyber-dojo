#!/bin/bash

echo
echo "======$1======"
rm -rf ../../coverage/.resultset.json
../testrb . 2>&1 | tee log.tmp
cp -R ../../coverage/* .
ruby ../print_coverage_percent.rb index.html $1 | tee -a log.tmp

# If I am in the test/lib dir and I execute each of the
# tests from the command line, one by one, then
# ls -al in the test/cyberdojo folder confirms that
# these individual commands do not alter the rights
# of the test/cyberdojo/katas dir.
# However if I am in the test/lib dir and I run
# testrb .
# then ls -al in the test/cyberdojo folder confirms that
# the test/cyberdojo/katas dir has had its rights reset.
# which testrb says /usr/local/bin/testrb
# cat /usr/local/bin/testrb says
#
# #!/usr/local/bin/ruby
# require 'test/unit'
# exit Test::Unit::AutoRunner.run(true)
#
# Created a testrb file in test/ as follows
# #!/usr/bin/env ruby
# require 'test/unit'
# exit Test::Unit::AutoRunner.run(true)
#
# and
# chown www-data testrb
# chgrp www-data testrb
# chmod +x testrb
#
# but still this resets the test/cyberdojo/katas folder
# Nothing to do with true parameter to AutoRunner.
# I think I need to set the sticky bit on the
# test/cyberdojo folder rather than the test/cyberdojo/katas
# folder.
