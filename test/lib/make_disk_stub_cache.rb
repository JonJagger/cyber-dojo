#!/usr/bin/env ruby

# traverses languages/ and exercises/ and creates
# cache.json file on disk for use in unit-tests

require_relative '../../admin_scripts/lib_domain'

$cache = { }

dojo.exercises.each do |exercise|
  $cache[exercise.path + 'instructions'] = exercise.instructions
end

ENV['CYBER_DOJO_RUNNER_CLASS_NAME'] = 'HostRunner'

dojo.languages.each do |language|
  $cache[language.path + 'manifest.json'] = dojo.disk[language.path].read('manifest.json')
  language.visible_files.each do |filename,content|
    $cache["#{language.path}#{filename}"] = content
  end  
end

File.write('/var/www/cyber-dojo/test/lib/disk_stub_cache.json', JSON.unparse($cache.sort))




