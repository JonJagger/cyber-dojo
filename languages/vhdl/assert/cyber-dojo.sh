# Imports all vhdl files into workspace
rm work-obj93.cf
ghdl -i *.vhdl

# Scrapes the workspace file for all entity names
entities=$(grep entity work-obj93.cf | cut -d \  -f 4)
echo $entities;

# Compilation step
compilation_successful=true
for entity in $entities; do
   if ! ghdl -m $entity; then
      compilation_successful=false
   fi
done

if [ "$compilation_successful" = false ] ; then
   echo "Encountered a compilation error"
   exit 1
fi

# Simulation step
simulation_successful=true
for entity in $entities; do
   if ! ghdl -r $entity; then
      simulation_successful=false
   fi
done

if [ "$simulation_successful" = true ] ; then
   echo "All tests passed!"
   exit 0
fi

exit 1
