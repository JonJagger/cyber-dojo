
# ExecuteAround test-runner which
# 1. checks if tests alter the current git user!
#     we don't want any confusion between the git repo created
#     in a test (for an animal) and the main git repo of cyber-dojo!
# 2. collect and processes coverage stats
# 
# Assumed to be run from /var/www/cyber-dojo/test/*/ folder
# Either by running a single test 
#   $ cd /var/www/cyber-dojo/test/lib
#   $ ./git_test.rb
# Or by running all the tests in one folder
#   $ cd /var/www/cyber-dojo/test/lib
#   $ ./run_all.sh
# Or by running all the tests
#   $ cd /var/www/cyber-dojo/test
#   $ ./run_all.sh

GIT_USER_NAME_BEFORE=`git config user.name`

rm -rf ../../coverage/.resultset.json
 
cat $@ | tail -n +2 > temp.xx
ruby temp.xx 2>&1 | tee log.tmp
rm temp.xx

cp -R ../../coverage/* .
ruby ../print_coverage_percent.rb index.html $1 | tee -a log.tmp

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

 
