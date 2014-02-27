
modules=( app_helpers app_lib app_models lib integration app_controllers )
echo
for module in ${modules[@]}
do
    echo "========================================== $module "
    cd $module
    ./run_all.sh
    cd ..
done
echo
echo

for module in ${modules[@]}
do
    echo "======$module======"
    tail -5 $module/log.tmp | head -1
    tail -3 $module/log.tmp | head -1
    tail -1 $module/log.tmp
done
echo
