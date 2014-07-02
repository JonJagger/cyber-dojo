#!/bin/bash

# after running this check the coverage in index.html

echo approval
./test_approval.rb
echo avatar
./test_avatar.rb
echo git_diff_view
./test_git_diff_view.rb
echo kata
./test_kata.rb
echo languages
./test_languages.rb
echo lights
./test_lights.rb
echo sandbox
./test_sandbox.rb
echo timeout
./test_timeout.rb
echo zombie_shells
./test_zombie_shells.rb
