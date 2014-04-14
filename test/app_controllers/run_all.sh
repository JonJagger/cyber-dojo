
# after running this check the coverage in index.html

echo '' > log.tmp
echo '' > run_all.tmp

for TEST in *.rb ; do
    cat $TEST >> run_all.tmp
done
ruby run_all.tmp 2>&1 | tee -a log.tmp
cp -R ../../coverage/* .
ruby ../perc.rb index.html app/controllers | tee -a log.tmp

rm run_all.tmp
