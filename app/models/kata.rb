
class Kata

  def initialize(dojo, kata_name)
    @dojo = dojo
    @name = kata_name
    read_manifest
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

  def new_avatar(name)
    Avatar.new(self, name)
  end

  def avatars
    result = []
    Avatar.names.each do |avatar_name|
      path = folder + '/' + avatar_name
      result << new_avatar(avatar_name) if File.exists?(path)
    end
    result
  end

  def folder
    @dojo.folder + '/' + name
  end

private
  
  def read_manifest
    @visible = {}
    @hidden_filenames = []
	@hidden_pathnames = []

    path = folder + '/' + 'kata_manifest.rb'
    if File.exists?(path)
      @manifest = eval IO.read(path)
      @manifest.each do |key,value|
        if key == :file_set_names
          read_file_sets(value)
        end
      end
    end
  end

  def read_file_sets(names)
    names.each do |file_set_name|
      path = RAILS_ROOT + '/' + 'katalogue' + '/' + file_set_name
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


