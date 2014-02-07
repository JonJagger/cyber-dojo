
modules=( helpers lib models integration controllers )

for module in ${modules[@]}
do    
    echo
    echo "====================================="
    echo ">>>>$module<<<<"
    cd $module
    ./run_all.sh
    cd ..
done

echo
echo
echo
echo "====================================="

for module in ${modules[@]}
do
    greenness=`grep "assertions," $module/run_all_log.tmp`
    duration=`grep "Finished tests" $module/run_all_log.tmp`
    coverage=`cat $module/coverage.tmp`
    echo $module
    echo "   $greenness"
    echo "   $duration"
    echo "   $coverage"
    echo
done

