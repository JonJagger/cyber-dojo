
class KataFileSet

  def initialize(name)
    @folder = 'katalogue' + '/' + name
    @manifest = eval IO.read(@folder + '/' + 'manifest.rb')
  end

  def visible
    visible_files = {}
    @manifest[:visible_filenames].each do |filename|
      visible_files[filename] = {}
      visible_files[filename][:content] = IO.read(folder + '/' + filename)
    end
    visible_files
  end

  def hidden
    @manifest[:hidden_filenames] || []
  end

  def unit_test_framework
    @manifest[:unit_test_framework]
  end

  def folder
    @folder
  end

end


