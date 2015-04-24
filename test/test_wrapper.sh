
# ExecuteAround test-runner which...
# 1. checks if tests alter the current git user!
#     we don't want any confusion between the git repo created
#     in a test (for an animal) and the main git repo of cyber-dojo!
# 2. collect and processes coverage stats
# 
# Programmed for these three cases...
# 1. running a single test (you must in the test's folder)
#    $ cd /var/www/cyber-dojo/test/lib
#    $ ./git_test.rb
# 2. running all the tests in one folder (you must be in that folder)
#   $ cd /var/www/cyber-dojo/test/lib
#   $ ./run_all.sh
# 3. running all the tests in all the folders (you must be in test folder)
#   $ cd /var/www/cyber-dojo/test
#   $ ./run_all.sh

GIT_USER_NAME_BEFORE=`git config user.name`

rm -rf ../../coverage/.resultset.json
 
# Ok. Something odd here. Ruby (on my mac book) is *not* ignoring
# the first shebang line in test/*_test.rb files.
# So I'm stripping the first shebang line using tail. Yeuch!
# 
# filename/line-numbers reported in failing test will only be 
# helpful for running single tests.

cat $@ | tail -n +2 > temp.xx
ruby temp.xx 2>&1 | tee log.tmp

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

 
