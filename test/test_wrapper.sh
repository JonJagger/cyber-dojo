
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ExecuteAround test-runner which...
#
# 1. checks if tests alter the current git user!
#    I don't want any confusion between the git repo created
#    in a test (for an animal) and the main git repo of cyber-dojo!
#
# 2. collects and processes coverage stats
# 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Programmed for three cases...
#
# 1. running a single test (you must in the test's folder)
#    $ cd /var/www/cyber-dojo/test/app_model
#    $ ./exercises_test.rb
#
# 2. running all the tests in one folder (you must be in that folder)
#   $ cd /var/www/cyber-dojo/test/lib
#   $ ./run_all.sh
#
# 3. running all the tests in all the folders (you must be in test folder)
#   $ cd /var/www/cyber-dojo/test
#   $ ./run_all.sh
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ok. Something odd here. Ruby (on my mac book) is *not* ignoring
# the first shebang line in test/*.rb files.
# So I'm creating a temp file by stripping the first shebang line.
# Yeuch! This makes the line-number in any diagnostic off by one.
# I fix that by putting an extra line at the top of the temp file.
# It also makes the (temp) filename wrong in any diagnostics.
# If a single test file is being run I base the temp filename on
# its filename which helps.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

wrapper_test_log='WRAPPER.log.tmp'

echo 'test_wrapper.sh....'

#pwd                       # eg  /var/www/cyber-dojo/test/app_lib
cwd=${PWD##*/}             # eg  app_lib
module=${cwd/_//}          # eg  app/lib
echo $module

if [ "$#" -eq 1 ]; then
  filename=$1
else
  filename='all_tests'
fi
wrapped_filename="$filename.WRAPPED"

GIT_USER_NAME_BEFORE=`git config user.name`

# Add an extra line
echo '' > $wrapped_filename

cat ${*} | tail -n +2 >> $wrapped_filename

rm -rf ../../coverage/.resultset.json
ruby $wrapped_filename 2>&1 | tee $wrapper_test_log
rm $wrapped_filename
cp -R ../../coverage/* .
ruby ../print_coverage_percent.rb index.html $module | tee -a $wrapper_test_log

GIT_USER_NAME_AFTER=`git config user.name`

if [ "$GIT_USER_NAME_BEFORE" != "$GIT_USER_NAME_AFTER" ]; then
  echo "--------------------------------------"
  echo " META TEST FAILURE!"
  echo "--------------------------------------"
  echo "Before running testrb"
  echo '  >git config user.name'
  echo "  $GIT_USER_NAME_BEFORE"
  echo
  echo "After running testrb"
  echo '  >git config user.name'
  echo "  $GIT_USER_NAME_AFTER"
  echo "--------------------------------------"
fi

 
