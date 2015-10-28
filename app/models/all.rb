
%w(
  external_parent_chain
  output_cleaner
  output_truncater
  manifest_property
  dojo
  caches
  language
  languages_rename
  languages
  exercise
  exercises
  avatar
  avatars
  kata
  katas
  sandbox
  tag
).each { |sourcefile| require_relative './' + sourcefile }
