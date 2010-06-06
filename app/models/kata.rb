
class Kata

  def initialize(dojo, id, name = "", readonly = false)
    @dojo = dojo
    @id = id
    read_manifest
    @avatar = Avatar.new(self, name) if name != ""
    @readonly = readonly
  end

  def id
    @id.to_s
  end

  def readonly
    @readonly
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

  def avatar
    @avatar
  end

  def avatars
    result = []
    Avatar.names.each do |avatar_name|
      path = folder + '/' + avatar_name
      result << Avatar.new(self, avatar_name) if File.exists?(path)
    end
    result
  end

  def run_tests(manifest)
    File.open(folder, 'r') do |f|
      flock(f) do |lock|
        run_tests_output = TestRunner.run_tests(self, manifest)
        test_info = RunTestsOutputParser.new().parse(self, run_tests_output)
        avatar.save(manifest, test_info)
      end
    end
  end

  def folder
    @dojo.folder + '/' + id
  end

private
  
  def read_manifest
    @visible = {}
    @hidden_filenames = []
	@hidden_pathnames = []

    @manifest = eval IO.read(folder + '/' + 'kata_manifest.rb')
    @manifest.each do |key,value|
      if key == :file_set_names
        read_file_sets(value)
      end
    end
    #@visible['run_tests_output'] = { :content => "" }
  end

  def read_file_sets(names)
    names.each do |file_set_name|
      folder = 'katalogue' + '/' + file_set_name
      file_set = eval IO.read(folder + '/' + 'manifest.rb')
	  file_set.each do |key,value|
		if key == :visible_filenames
          @visible.merge! read_visible(folder, value)
        elsif key == :hidden_filenames
          @hidden_filenames += value
          @hidden_pathnames += read_hidden_pathnames(folder, value)
        else
          @manifest[key] = value
        end
      end
    end    
  end

  def read_visible(folder, filenames)
    visible_files = {}
    filenames.each do |filename|
      visible_files[filename] = { :content => IO.read(folder + '/' + filename) }
    end
    visible_files
  end

  def read_hidden_pathnames(folder, filenames)
    pathed = []
    filenames.each do |filename|
      pathed << folder + '/' + filename
    end
    pathed
  end

end


