# WORK IN PROGRESS...

#rm -rf ../../coverage/.resultset.json

GIT_USER_NAME_BEFORE=`git config user.name`
 
cat $@ | tail -n +2 > temp.xx
ruby temp.xx 2>&1 | tee log.tmp
rm temp.xx

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

#cp -R ../../coverage/* .
#ruby ../print_coverage_percent.rb index.html $1 | tee -a log.tmp
 
