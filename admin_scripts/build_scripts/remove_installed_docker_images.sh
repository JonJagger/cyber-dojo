#!/bin/bash

./list_installed_docker_images.sh | xargs -I % docker rmi %

