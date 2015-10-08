
%w(
  external_parent_chain
  manifest_property
  dojo
  language
  languages_rename
  languages
  exercise
  exercises
  update_cyber_dojo_sh
  avatar
  avatars
  kata
  katas
  sandbox
  tag
).each { |sourcefile| require_relative './' + sourcefile }
