
# after running this check the coverage in index.html

echo '' > run_all.tmp

cat exercises_tests.rb >> run_all.tmp
cat languages_tests.rb >> run_all.tmp
cat     katas_tests.rb >> run_all.tmp
cat   avatars_tests.rb >> run_all.tmp

ruby run_all.tmp 2>&1
