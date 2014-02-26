
modules=( app_helpers app_lib app_models lib integration app_controllers )
echo
for module in ${modules[@]}
do
    echo "========================================== $module "
    cd $module
    ./run_all.sh
    cat coverage.tmp
    cd ..
done
echo
echo

for module in ${modules[@]}
do
    echo -n "$module: "
    cat $module/coverage.tmp
done
echo
