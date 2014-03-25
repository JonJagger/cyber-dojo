
# after running this check the coverage in index.html

echo '' > log.tmp
echo '' > run_all.tmp

cat linux_paas_tests.rb >> run_all.tmp
cat linux_paas_exercise_tests.rb >> run_all.tmp
cat linux_paas_exercises_tests.rb >> run_all.tmp
cat linux_paas_language_tests.rb >> run_all.tmp
cat linux_paas_languages_tests.rb >> run_all.tmp
cat linux_paas_dojo_tests.rb >> run_all.tmp
cat linux_paas_kata_tests.rb >> run_all.tmp
cat linux_paas_sandbox_tests.rb >> run_all.tmp

ruby run_all.tmp 2>&1 | tee -a log.tmp
cp -R ../../coverage/* .
ruby ../perc.rb index.html app/models | tee -a log.tmp

rm run_all.tmp
