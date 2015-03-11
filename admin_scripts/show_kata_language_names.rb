#!/usr/bin/env ruby

require_relative 'lib_domain'


dojo = create_dojo

puts
names = { }
dot_count = 0
dojo.katas.each do |kata|
  name = kata.manifest['language']
  names[name] ||=  []
  names[name] << kata.id
  dot_count += 1
  print "\rworking" + dots(dot_count)
end
puts
puts

names.keys.sort.each do |name| 
  p "#{name} #{names[name].size} #{names[name][0]}"
end

# The languages/ sub-folder needs more work.
# Some existing dojos have language:"Java-1.8_Junit" 
# in their manifest with the - part of the name
# Also  Ruby-1.9.3 ---> Ruby1.9.3
# Also  Ruby-2.1.3 ---> Ruby2.1.3
# Do some dojo's have a manifest language: entry with , as a separator
#    and some with a - separator? 
#
# TODO: Run this script on main server to gather all used language: entries
#
# RULE: - and , are not allowed in a language folder name or a test folder name
#
# IDEA: From now on, store a versionless language name in a kata's
#       manifest.json file. Then use Languages.rename to map
#       to folder name which may have the latest version number.
#
#       Katas.create_kata_manifest(language, exercise, id, now)
#         {   ...
#             :language => language.name,
#             :exercise => exercise.name, 
#             ...
#         }
#       redo
#       Katas.create_kata_manifest(language, exercise, id, now)
#         {   ...
#             :language_name => ...,
#             :test_name => ...,
#             :exercise_name => ..., 
#             ...
#         }
#       Hmmm. exercise_name
#       Maybe create another script to look at the names of those
#       in all mainfests on the main server.
#       Then patch those up too?
#
# IDEA: Languages/manifest.json files looks like this
#       {   ...
#           "display_name": "C++, Igloo",
#           ...
#       }
#       This could also be reworked into two names.
#       {
#           ...
#           "language_display_name": "C++",
#           "test_display_name": "Igloo",
#           ...
#       }
#
#
# NOTE: Only way ambiguity can arise is if there are two versions of
#       the same language+test, eg g++4.8.1-assert and g++4.9-assert
#       So never do that. And aim to have two versions of the same
#       language only when upgrading, or when the tests are split 
#       some in one version and some in another version. Eg
#       C++ (g++4.8.1 and g++4.9) and Ruby (1.9.3 and 2.1.3)
#
# TODO: Write a script to fix up all the katas on the main server
#       so the language entry in their manifests is fixed and is
#       split into two entries, one for the language name and one for 
#       the test name.
#


