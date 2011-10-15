require 'Folders'

class ConfigureController < ApplicationController
  
  include Folders
  
  # TODO: create all starting filesets for all language x kata combinations
  # TODO: save button needs to have form that is submitted to save method on this class
  # TODO: flash style notice if dojo name is already used.
  # TODO: add currentFilename and switching language/kata tries to retain that filename
  # TODO: switch to using this to configure a dojo in one page rather than two.
  
  # The result of configuring should be that the new dojo is setup.
  # This means that the sha1 folders have been created.
  # IDEA: I could also make a /sandbox folder off the dojo's root and
  # containing all the files ready to be xcopied to an avatar's
  # home folder when the avatar is created.
    
  def choose_name_language_kata
    configure(params)
    starting_filesets_root = params[:starting_filesets_root]    
    @languages = folders_in(starting_filesets_root)
    @current_language = params['current_language'] || 'Ruby' #@languages.shuffle[0]
    @katas = folders_in(starting_filesets_root + '/' + @current_language)
    
    # TODO: if params['kata'] is a valid for current language then use it
    #       else choose random kata.
    @current_kata = params['current_kata'] || @katas.shuffle[0]

    manifest = StartingFileSet.new(starting_filesets_root, @current_language, @current_kata)
    
    @starting_files = manifest.visible_files
    @starting_filenames = @starting_files.keys.sort
    # TODO: if params['current_filename'] is in current language+kata then use it
    #       else if instructions is in it, use that, e
    #       else choose random
    @current_filename = instructions_else_random(@starting_filenames)
  end

private

  def instructions_else_random(starting_filenames)
    prefer = 'instructions'
    starting_filenames.include?(prefer) ? prefer : random(starting_filenames)
  end
  
  def random(filenames)
    filenames.shuffle[0]
  end
  
end
