
%w{
  Chooser 
  FileDeltaMaker
  GitDiff 
  GitDiffBuilder 
  GitDiffParser 
  LineSplitter
  ReviewFilePicker
  PrevNextRing
  MakefileFilter 
  OutputParser 
  TdGapper
}.each { |sourcefile| require_relative './' + sourcefile }

