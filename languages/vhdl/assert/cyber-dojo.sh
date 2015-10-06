#!/bin/bash

ghdl -i *.vhdl

compilation_successful=true
for file in *.vhdl; do
   entity=${file%.*}
   if ! ghdl -m $entity; then
      compilation_successful=false
   fi
done

if [ "$compilation_successful" = false ] ; then
   echo "Encountered a compilation error"
   exit 1
fi

simulation_successful=true
for file in *.vhdl; do
   entity=${file%.*};
   if ! ghdl -r $entity; then
      simulation_successful=false
   fi
done

if [ "$simulation_successful" = true ] ; then
   echo "All tests passed!"
   exit 0
fi

exit 1
