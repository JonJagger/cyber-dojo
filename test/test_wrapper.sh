#!/bin/bash
#set -e

if [ "$#" -eq 0 ]; then
  echo
  echo '  How to use test_wrapper.sh'
  echo
  echo '  1. running specific tests in one folder'
  echo "     $ cd test/app_model"
  echo '     $ ./run.sh <ID*>'
  echo
  echo '  2. running all the tests in one folder'
  echo "     $ cd test/app_model"
  echo '     $ ./run.sh'
  echo
  echo '  3. running all the tests in all the folders'
  echo "     $ cd test"
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
# check if tests alter the current git user!
# I don't want any confusion between the git repo created
# in a test (for an animal) and the main git repo of cyber-dojo!

gitUserNameBefore=`git config user.name`

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
HOME_DIR="$( cd "$( dirname "${0}" )/.." && pwd )"

# TODO: check for environment-variables being set here?
# TODO: if not set provide defaults (and say so)

export CYBER_DOJO_LANGUAGES_ROOT=${HOME_DIR}/app/languages
export CYBER_DOJO_EXERCISES_ROOT=${HOME_DIR}/app/exercises

export CYBER_DOJO_KATAS_CLASS=HostDiskKatas
export CYBER_DOJO_SHELL_CLASS=HostShell
export CYBER_DOJO_DISK_CLASS=HostDisk
export CYBER_DOJO_GIT_CLASS=HostGit
export CYBER_DOJO_LOG_CLASS=MemoryLog

export CYBER_DOJO_RUNNER_TIMEOUT=10
export CYBER_DOJO_RUNNER_SUDO=''

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# coverage is off

ruby -e "%w( ${testFiles[*]} ).map{|file| './'+file}.each { |file| require file}" -- ${args[*]}

#rm -rf ../../coverage/.resultset.json
#mkdir -p coverage
#wrapper_test_log='coverage/WRAPPER.log.tmp'
#ruby $wrapped_filename -- ${args[*]} 2>&1 # | tee $wrapper_test_log
#rm $wrapped_filename
#cp -R ../../coverage .
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#pwd                       # eg  .../cyber-dojo/test/app_lib
cwd=${PWD##*/}             # eg  app_lib
module=${cwd/_//}          # eg  app/lib
#ruby ../print_coverage_percent.rb index.html $module | tee -a $wrapper_test_log
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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


