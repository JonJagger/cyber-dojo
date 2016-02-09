#!/bin/bash

#
# I'm no longer using a katas data-container as it does not seem
# possible for a sibling docker-container's access to be limited
# to a katas/ sub-folder.
#
# TODO: When building a new docker-in-docker web server I'll need
# to volume mount the original /var/www/cyber-dojo/katas folder
# if its exists...
# That's not nice. Better to move it to a new chosen location?
# Also, the katas folder will need chown/chmod/setfacl? settings

