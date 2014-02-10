
# after running this check the coverage in index.html

echo '' > run_one_log.tmp

ruby $1 2>&1 | tee -a run_one_log.tmp
cp -R ../../coverage/* .
ruby ../perc.rb index.html integration > coverage.tmp
cat coverage.tmp
echo
