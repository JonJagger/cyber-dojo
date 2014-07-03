
export CYBERDOJO_USE_HOST=true

modules=( app_helpers app_lib app_models lib integration app_controllers )
echo
for module in ${modules[@]}
do
    echo "======$module======"
    cd $module
    ./run_all.sh
    cd ..
done
echo
echo

# summary
for module in ${modules[@]}
do
    echo "======$module======"
    tail -5 $module/log.tmp | head -1
    tail -3 $module/log.tmp | head -1
    tail -1 $module/log.tmp
    rm $module/log.tmp
done
echo
