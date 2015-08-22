#!/bin/bash

docker images | grep -oe "cyberdojofoundation\/[\_a-z0-9\.\-]*"

