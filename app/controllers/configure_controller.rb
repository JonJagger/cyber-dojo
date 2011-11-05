require 'Folders'

class ConfigureController < ApplicationController
  
  include Folders
  
  # TODO: save button needs to have form that is submitted to save method on this class
  # TODO: flash style notice if dojo name is already used.
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
    @current_language = params['current_language'] || random(@languages)
    @katas = folders_in(starting_filesets_root + '/' + @current_language)    
    @current_kata = from_prefer_otherwise(@katas, params['current_kata'], random(@katas))
    manifest = StartingFileSet.new(starting_filesets_root, @current_language, @current_kata)
    
    @starting_files = manifest.visible_files
    @starting_filenames = @starting_files.keys.sort
    
    @current_filename =
      from_prefer_otherwise(
        @starting_filenames,
        params['current_filename'],
        from_prefer_otherwise(@starting_filenames, 'instructions', random(@starting_filenames)
      ))
  end

private

  def from_prefer_otherwise(from, prefer, otherwise)
    from.include?(prefer) ? prefer : otherwise
  end
  
  def random(array)
    array.shuffle[0]
  end
  
end
