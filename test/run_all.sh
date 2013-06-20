
modules=( helpers lib models controllers)

for module in ${modules[@]}
do
    cd $module
    ./run_all.sh
    cd ..
done

echo; echo; echo '----------------------------------------'

for module in ${modules[@]}
do
    echo "$module" | tr '[a-z]' '[A-Z]'
    grep "assertions," $module/run_all_log.tmp
    cat $module/coverage.tmp
    echo
done
