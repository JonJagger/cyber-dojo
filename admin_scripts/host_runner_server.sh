#!/bin/bash

# Run a local server using the host to process [test] events
# (Deprecated)

export CYBER_DOJO_RUNNER_CLASS=HostRunner
rails s
unset CYBER_DOJO_RUNNER_CLASS