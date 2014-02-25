
modules=( app_helpers app_lib app_models lib integration app_controllers )
echo
for module in ${modules[@]}
do
    echo "========================================== $module "
    cd $module
    ./run_all.sh
    cd ..
done
