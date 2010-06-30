
class Kata

  def self.names
    # In a multi-kata dojo, if you list the katas
    # alphabetically there is a strong likelihood that each
    # station will simply pick the first entry.
    # Listing the katas in a random increases the chances
    # multiple katas will be selected, which hopefully
    # will increase the chances of collaboration - the game's
    # prime directive.
    Dir.entries(RAILS_ROOT + '/katas').select do |name|
      name != '.' and name != '..'
    end.sort_by {rand}
  end

  def initialize(language_name, kata_name)
    @language = language_name
    @name = kata_name
    read_manifest(language_name, kata_name)
  end

  def language
    @language
  end

  def name 
    @name.to_s
  end

  def max_run_tests_duration
 	# default max_run_tests_duration = 10 seconds
    (@manifest[:max_run_tests_duration] || 10).to_i      
  end

  def tab
    # default tab_size = 4
    " " * (@manifest[:tab_size] || 4)
  end

  def unit_test_framework
    @manifest[:unit_test_framework]
  end
  
  def visible
    @visible
  end

  def hidden_pathnames
    @hidden_pathnames
  end

  def hidden_filenames
    @hidden_filenames
  end

private

  def read_manifest(language_name, kata_name)
    @manifest = {}
    @visible = {}
    @hidden_filenames = []
	@hidden_pathnames = []
    read_file_set('languages/' + language_name)
    read_file_set('katas/' + kata_name)
  end
  
  def read_file_set(file_set_name)
    path = RAILS_ROOT + '/' + file_set_name
    file_set = eval IO.read(path + '/' + 'manifest.rb')
    file_set.each do |key,value|
	  if key == :visible_filenames
        @visible.merge! read_visible(path, value)
      elsif key == :hidden_filenames
        @hidden_filenames += value
        @hidden_pathnames += read_hidden_pathnames(path, value)
      else
        @manifest[key] = value
      end
    end    
  end

  def read_visible(file_set_folder, filenames)
    visible_files = {}
    filenames.each do |filename|
      visible_files[filename] = 
        { :content => IO.read(file_set_folder + '/' + filename),
          :caret_pos => 0 
        }
    end
    visible_files
  end

  def read_hidden_pathnames(file_set_folder, filenames)
    pathed = []
    filenames.each do |filename|
      pathed << file_set_folder + '/' + filename
    end
    pathed
  end

end


