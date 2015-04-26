
#export CYBER_DOJO_USE_HOST=true

modules=( lib )
#app_helpers app_lib app_models lib languages integration app_controllers )

echo
for module in ${modules[@]}
do
    echo
    echo "======$module======"  
    cd $module
    ./run_all.sh
    cd ..
done
echo
echo

./print_summary.rb | tee coverage.txt
