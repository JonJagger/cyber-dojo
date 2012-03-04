
for TEST in *.rb ; do
    cat $TEST >> run_all.tmp
done
ruby run_all.tmp
rm run_all.tmp
