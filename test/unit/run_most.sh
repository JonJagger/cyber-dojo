
echo '' > run_most.tmp
for TEST in *.rb
do 
    if [ $TEST != 'simulated_full_kata_tests.rb' ] &&
       [ $TEST != 'installation_tests.rb' ] &&
       [ $TEST != 'time_out_tests.rb' ]
    then
        cat $TEST >> run_most.tmp
    fi
done
ruby run_most.tmp
rm run_most.tmp
