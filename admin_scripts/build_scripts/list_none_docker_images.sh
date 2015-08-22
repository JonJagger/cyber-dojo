#!/bin/bash

docker images | grep "<none>" | awk "{print \$3}"

