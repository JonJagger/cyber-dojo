
# after running this check the coverage under the
# app/controllers tab of coverage/index.html

echo '' > run_all.tmp
for TEST in *.rb ; do
    cat $TEST >> run_all.tmp
done
ruby run_all.tmp
cp -R ../../coverage/* .
ruby ../perc.rb index.html app/controllers > coverage.tmp
cat coverage.tmp