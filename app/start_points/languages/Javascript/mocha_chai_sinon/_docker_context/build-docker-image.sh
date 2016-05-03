#!/bin/bash

docker build -t cyberdojofoundation/javascript-node_mocha_chai_sinon .

# I tried calling this
#               cyberdojo/javascript-0.10.15_mocha_chai_sinon
# but I got an error message saying the name had to be
# less than 31 characters. Is this a new constraint?
# I'm sure I have containers whose names are more than 31

# Trying the name "cyberdojofoundation/javascript-0.10.25_mocha_chai_sinon"
# as apparently the length limit has been removed
