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
cd ../functional
./run_all.sh
cd ..

