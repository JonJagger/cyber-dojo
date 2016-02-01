#!/bin/bash

cyberDojoHome=/var/www/cyber-dojo

if [ "$#" -eq 0 ]; then
  echo
  echo '  How to use test_wrapper.sh'
  echo
  echo '  1. running specific tests in one folder'
  echo "     $ cd $cyberDojoHome/test/app_model"
  echo '     $ ./run.sh <ID*>'
  echo
  echo '  2. running all the tests in one folder'
  echo "     $ cd $cyberDojoHome/test/app_model"
  echo '     $ ./run.sh'
  echo
  echo '  3. running all the tests in all the folders'
  echo "     $ cd $cyberDojoHome/test"
  echo '     $ ./run.sh'
  echo
  exit
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# collect trailing arguments to forward to tests

while (( "$#" )); do
  if [[ $1 == *.rb ]]; then
    testFiles+=($1)
    shift
  else
    args=($*)
    break
  fi
done

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# It seems Ruby does *not* ignore the first shebang line
# in test/*.rb files when running a .rb file explicitly ala
#    $ ruby test_parity.rb
# So I create a temp file with the first line stripped off.
# Yeuch!
# This makes the line-number in any diagnostic off by one.
# I fix that by putting an extra line at the top of the temp file.
# Yeuch!
# It also makes the (temp) filename wrong in any diagnostics.
# If a single test file is being run I base the temp filename on
# its filename which helps.

if [ ${#testFiles[@]} -eq 1 ]; then
  filename=${testFiles[0]}
else
  filename='all_tests'
fi
wrapped_filename="$filename.WRAPPED"
(echo ''; (cat ${testFiles[*]}) | tail -n +2) > $wrapped_filename

#echo "EARLY EXIT"
#exit

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# check if tests alter the current git user!
# I don't want any confusion between the git repo created
# in a test (for an animal) and the main git repo of cyber-dojo!

gitUserNameBefore=`git config user.name`

rm -rf ../../coverage/.resultset.json
mkdir -p coverage
wrapper_test_log='coverage/WRAPPER.log.tmp'

ruby $wrapped_filename -- ${args[*]} 2>&1 | tee $wrapper_test_log

rm $wrapped_filename
cp -R ../../coverage .
#pwd                       # eg  /var/www/cyber-dojo/test/app_lib
cwd=${PWD##*/}             # eg  app_lib
module=${cwd/_//}          # eg  app/lib
ruby ../print_coverage_percent.rb index.html $module | tee -a $wrapper_test_log

gitUserNameAfter=`git config user.name`

if [ "$gitUserNameBefore" != "$gitUserNameAfter" ]; then
  echo --------------------------------------
  echo META TEST FAILURE!
  echo --------------------------------------
  echo Before
  echo '  $ git config user.name'
  echo "  $ $gitUserNameBefore"
  echo
  echo After
  echo '  $ git config user.name'
  echo "  $ $gitUserNameAfter"
  echo --------------------------------------
fi


