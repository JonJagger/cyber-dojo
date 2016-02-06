#!/bin/bash

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${MY_DIR} > /dev/null

# Building the katas image (data container) from any
# existing files in the /var/www/cyber-dojo/katas folder.
# This is part of installing a new cyber-dojo server.

../build-katas-image.sh

EXIT_STATUS=$?

popd > /dev/null

exit ${EXIT_STATUS}
