#!/bin/bash

# Don't use this if there are data-only containers.

docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
