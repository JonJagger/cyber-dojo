jasmineConfigFile=jasmine.json

echo '{' > $jasmineConfigFile
echo '    "spec_dir": ".",' >> $jasmineConfigFile
echo '    "spec_files": [ "*[sS]pec.js" ]' >> $jasmineConfigFile
echo '}' >> $jasmineConfigFile

jasmine JASMINE_CONFIG_PATH=./$jasmineConfigFile
