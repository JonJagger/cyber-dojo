# Change the version of Node.js to use, see https://nodejs.org
# to see the supported ES6 features see: https://kangax.github.io/compat-table/es6/
# 4.1.1 supports some ES6 (about 50%) features: https://nodejs.org/en/docs/es6/
# 0.12.7 is the latest version without most ES6 (about 20%) features: https://nodejs.org/docs/latest-v0.12.x/api/
#
# set the version to use:
#NODE_VERSION=0.12.7
NODE_VERSION=4.2.1
#
# Create a dummy file config.js for qunit call --code needs a js file
qunitDummyConfigFile=config.js
echo '' > $qunitDummyConfigFile
#
# Use npm package 'n' to call qunitwith selected node version:
if [ -f .jshintrc ]
  then
    n use $NODE_VERSION /usr/lib/node_modules/jshint/bin/jshint --config .jshintrc *.js
fi
n use $NODE_VERSION /usr/local/bin/qunit --code $qunitDummyConfigFile --tests *-test.js
