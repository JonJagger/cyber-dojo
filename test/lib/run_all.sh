
# after running this check the coverage in index.html

echo '' > run_all.tmp
for TEST in *.rb ; do
    cat $TEST >> run_all.tmp
done
ruby run_all.tmp
cp -R ../../coverage/* .
ruby ../perc.rb index.html lib > coverage.tmp
cat coverage.tmp