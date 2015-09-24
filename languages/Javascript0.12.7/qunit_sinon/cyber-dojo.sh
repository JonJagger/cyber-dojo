qunitDummyConfigFile=config.js
echo '' > $qunitDummyConfigFile
qunit --code $qunitDummyConfigFile --tests *-test.js