cd unit
echo UNIT
./run_all.sh
cd ../lib
echo LIB
./run_all.sh
echo HELPERS
cd ../helpers
./run_all.sh
echo INTEGRATION
cd ../integration
./run_all.sh

