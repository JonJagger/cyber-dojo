
cd lib
echo '' > run_all_log.tmp
./run_all.sh 2>&1 | tee -a run_all_log.tmp
cd ..

cd helpers
echo '' > run_all_log.tmp
./run_all.sh 2>&1 | tee -a run_all_log.tmp
cd ..

cd models
echo '' > run_all_log.tmp
./run_all.sh 2>&1 | tee -a run_all_log.tmp
cd ..

cd controllers
echo '' > run_all_log.tmp
./run_all.sh 2>&1 | tee -a run_all_log.tmp
cd ..

echo
echo
echo

echo LIB
grep "assertions," lib/run_all_log.tmp
cat lib/coverage.tmp

echo HELPERS
grep "assertions," helpers/run_all_log.tmp
cat helpers/coverage.tmp

echo MODELS
grep "assertions," models/run_all_log.tmp
cat models/coverage.tmp

echo CONTROLLERS
grep "assertions," controllers/run_all_log.tmp
cat controllers/coverage.tmp
