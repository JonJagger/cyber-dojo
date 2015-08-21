#!/bin/bash

docker build -t cyberdojofoundation/javascript-mocha .

# I tried calling this
#               cyberdojo/javascript-0.10.15_mocha_chai_sinon
# but I got an error message saying the name had to be
# less than 31 characters. Is this a new constraint?
# I'm sure I have containers whose names are more than 31
