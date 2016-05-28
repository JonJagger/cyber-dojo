#!/bin/bash

cp ../project.clj .
docker build -t cyberdojofoundation/clojure_midje .
rm project.clj
