
%w(
  SetupChooser
  FileDeltaMaker
  GitDiff
  GitDiffBuilder
  GitDiffParser
  LineSplitter
  ReviewFilePicker
  PrevNextRing
  MakefileFilter
  OutputColour
  TdGapper
).each { |sourcefile| require_relative './' + sourcefile }

