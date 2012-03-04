
for TEST in *.rb
do 
    if [ $TEST != 'simulated_full_kata_tests.rb' ] && [ $TEST != 'installation_tests.rb' ]
    then
        cat $TEST >> most.tmp
    fi
done
ruby most.tmp
rm most.tmp
