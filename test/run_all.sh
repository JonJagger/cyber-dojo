cd unit
echo UNIT
./run_most.sh
cd ../lib
echo LIB
./run_all.sh
echo HELPERS
cd ../helpers
./run_all.sh
echo FUNCTIONAL
cd ..
ruby functional/dojo_tests.rb
ruby functional/render_error_tests.rb

