
# after running this check the coverage in index.html

echo '' > run_all.tmp
echo '' > run_all_log.tmp

for TEST in *.rb ; do
    cat $TEST >> run_all.tmp
done
ruby run_all.tmp 2>&1 | tee -a run_all_log.tmp
cp -R ../../coverage/* .
ruby ../perc.rb index.html app/models > coverage.tmp
cat coverage.tmp

rm run_all.tmp
rm run_all_log.tmp
rm coverage.tmp
