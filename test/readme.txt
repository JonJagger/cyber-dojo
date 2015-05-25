
The tests are being refactored.
test/app_controllers/ has not been done yet.

------------------------------
Note
On the live server everything runs through Rails as the www-data user.

During development the user I am logged in as is not www-data.
In order to run some of the tests (the ones that aren't unit tests
and read/write/delete files on the actual hard disk) I therefore have
to put my user and the www-data user into a common group and
give this group ownership of /var/www/cyber-dojo/

$ sudo groupadd test-runner
$ sudo usermod -a -G test-runner www-data
$ sudo usermod -a -G test-runner jon
$ cd /var/www
$ sudo chown -R www-data:test-runner cyber-dojo
$ cd /var/www/cyber-dojo
$ sudo chmod -R 777 tests