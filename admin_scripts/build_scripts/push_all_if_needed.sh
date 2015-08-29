#!/bin/bash

./list_installed_docker_images.sh | xargs -I {} ./push_if_needed.sh {}

