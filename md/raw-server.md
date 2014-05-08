
Raw Server (deprecated)
=======================

All development is now focused on running cyber-dojo using a
[docker'd server](docker-server.md)

This is how cyber-dojo runs if docker is not installed or if
it is but the environment variable CYBERDOJO_USE_HOST is set.
This is useful primarily for running a personal cyber-dojo on
a laptop. In this mode, there is
  * NO PROTECTION, NO ISOLATION, NO SECURITY.
  * NO PROTECTION, NO ISOLATION, NO SECURITY.
  * NO PROTECTION, NO ISOLATION, NO SECURITY.


running your own raw cyber-dojo server
--------------------------------------
Install [VirtualBox](http://www.virtualbox.org/)
Download the TurnKey Linux image from
http://dl.dropbox.com/u/11033193/CyberDojo/Turnkey-CyberDojo-20120515.ova
(817MB) This image supports 13 languages (C, C++, C#, Coffeescript, Erlang,
Go, Haskell, Java, Javascript, Perl, PHP, Python, Ruby).
Run the ova file in VirtualBox. Mike Long has written some instructions for
this here
http://www.jaggersoft.com/CyberDojoTurnKeyLinuxVirtualBoxserverimageInstructions.pdf
The Virtual Box screen will tell you its IP address, eg 192.168.2.13
Put the URL into your browser. That's it!
Detailed instructions on building your own Turnkey server from scratch are here
http://jonjagger.blogspot.co.uk/2012/05/building-rails-3-turnkey-image.html


installing languages on a raw server
------------------------------------
The base rails3 image is available here (417MB)
http://dl.dropbox.com/u/11033193/CyberDojo/Turnkey-CyberDojo-20120515.base.ova
(see http://jonjagger.blogspot.co.uk/2012/05/building-rails-3-turnkey-image.html
for details on how I built it) and supports C, C++, Python, Perl and Ruby.
I installed the other 8+ languages onto this baseline rails 3 image (some of
which are included in the larger 817MB ova file above) as follows...

```
$ apt-get update
```
-----
Java (125MB)
```
$ apt-get install default-jdk
```
-------
C# (27MB)
```
$ apt-get install mono-gmcs
$ apt-get install nunit-console
$ cd /var/www/cyberdojo/languages/C#
$ rm *.dll
$ cp /usr/lib/cli/nunit.framework-2.4/nunit.framework.dll .
```
I edited the /var/www/cyberdojo/languages/C#/manifest.rb file thus
```
   :support_filenames => %w( nunit.framework.dll )
```
There was a permission issue. Using strace suggested the following
which fixed the problem
```
$ mkdir /var/www/.mono
$ chgrp www-data .mono
$ chown www-data .mono
```
-------
C# NUnit upgrade
I upgraded mono as follows (the server is Ubuntu 10.04 LTS)
```
$ sudo bash -c "echo deb http://badgerports.org lucid main >> /etc/apt/sources.list"
$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E1FAD0C
$ sudo apt-get update
$ sudo apt-get install libmono-corlib2.0-cil libmono-system-runtime2.0-cil libmono-system-web2.0-cil libmono-i18n2.0-cil libgdiplus
```
I tried to get NUnit 2.6 to work but it failed with
```
System.ApplicationException: Exception in TestRunnerThread --->
   System.NotImplementedException: The requested feature is not implemented.
   at NUnit.Core.TestExecutionContext.Save () [0x00000] in <filename unknown>:0
```
Googling seems to show this is a known problem!
So I backed up and backed up... until NUnit 2.5.10 which seems to work ok
and still supports the [TestFixture] attribute.
I installed all the new dlls into the gac
```
$ gacutil -i *.dll
```
nunit-console (the command in cyber-dojo.sh) is simply a  script file
which calls nunit-console.exe which is itself a CLI assembly. Viz
```
  #!/bin/sh
  exec /usr/bin/cli /usr/lib/nunit/nunit-console.exe "$@"
```
strace showed that nunit wanted to create some shadow folders...
```
$ chown -R www-data /tmp/nunit20/ShadowCopyCache
$ chgrp -R www-data /tmp/nunit20/ShadowCopyCache
```

-------
Erlang(26MB)
```
$ apt-get install erlang
```
------
Haskell (111MB)
```
$ apt-get install libghc6-hunit-dev
```
------
Go (44MB)
```
$ cd ~
$ wget http://go.googlecode.com/files/go.go1.linux-386.tar.gz
$ tar -C /usr/local -xzf go.go1.linux-386.tar.gz
$ rm go.go1.linux-386.tar.gz
```
I then added the following line to the end of /etc/apache2/envvars/
```
$ export PATH=$PATH:/usr/local/go/bin
```
-----
Javascript (63MB)
```
$ cd ~
$ git clone git://github.com/joyent/node.git
$ cd node
$ git checkout v0.6.17
$ ./configure
$ make
$ make install
$ cd ~
$ rm -r node
```
-----
CoffeeScript (3MB)
```
$ npm install --global jasmine-node
```
-----
PHP (3MB)
```
$ apt-get install phpunit
```
-----
C/C++ upgrade (80MB)
```
$ sudo apt-get install python-software-properties
$ sudo add-apt-repository ppa:ubuntu-toolchain-r/test
$ sudo apt-get update
$ sudo apt-get install gcc-4.7 g++-4.7
$ sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.4 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.4
$ sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.7 40 --slave /usr/bin/g++ g++ /usr/bin/g++-4.7
$ sudo update-alternatives --config gcc
```
and select 2. Finally (39MB)
```
$ sudo apt-get install valgrind
```
------
Groovy-JUnit
```
$ apt-get update
$ apt-get install curl
$ curl -s get.gvmtool.net | bash
$ gvm install groovy
```
I then added the following line to the end of /etc/apache2/envvars/
```
export PATH=$PATH:${location-of-groovy-bin}
```
This also gave me the three jars I needed.
```
junit-4.11.jar
groovy-all-2.1.5.jar
hamcrest-core-1.3.jar
```
------
Groovy-Spock
```
$ grape -Dgrape.root=$(pwd) install org.spockframework spock-core 0.7-groovy-2.0
```
this gave me the spock jar I needed.



pulling the latest cyberdojo github repo
----------------------------------------
You'll need the username and password. I will happily tell you these if
you email me: jon@jaggersoft.com
