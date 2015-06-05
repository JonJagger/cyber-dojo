
modules=( 
  app_helpers 
  app_lib 
  app_models 
  lib 
  # languages
  # integration 
  # app_controllers 
)

./../admin_scripts/make_disk_cache.rb

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

./print_coverage_summary.rb | tee test-summary.txt
