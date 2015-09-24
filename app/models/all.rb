
%w{
  ExternalParentChain
  ManifestProperty
  Dojo
  Language
  Languages
  Exercise
  Exercises
  Avatar
  Avatars
  Kata
  Katas
  Sandbox
  Tag
}.each { |sourcefile| require_relative './' + sourcefile }
