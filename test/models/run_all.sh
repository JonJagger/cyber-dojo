
# after running this check the coverage in index.html

echo '' > run_all.tmp
echo '' > run_all_log.tmp

for TEST in *.rb ; do
    cat $TEST >> run_all.tmp
done
ruby run_all.tmp 2>&1 | tee -a run_all_log.tmp
cp -R ../../coverage/* .
ruby ../perc.rb index.html app/models > coverage.tmp

echo
echo MODELS
grep "assertions," run_all_log.tmp 
cat coverage.tmp
echo
