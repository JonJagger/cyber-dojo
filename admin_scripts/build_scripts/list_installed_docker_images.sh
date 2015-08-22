#!/bin/bash

docker images | grep "cyberdojofoundation/" | awk "{print \$1}"

