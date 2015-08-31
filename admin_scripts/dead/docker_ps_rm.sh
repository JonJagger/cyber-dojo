#!/bin/bash

# Don't use this if there are data-only containers.

docker stop $(docker ps -aq) && docker rm $(docker ps -aq)
