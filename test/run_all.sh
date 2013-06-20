
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

echo LIB
grep "assertions," lib/run_all_log.tmp
echo HELPERS
grep "assertions," helpers/run_all_log.tmp
echo MODELS
grep "assertions," models/run_all_log.tmp
echo CONTROLLERS
grep "assertions," controllers/run_all_log.tmp
