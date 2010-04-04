
class KataFileSet

  def initialize(kata)
    @kata = kata
    @manifest = eval IO.read(folder + '/' + 'manifest.rb')
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
    if @manifest[:hidden_filenames]
      @manifest[:hidden_filenames]
    else
      []
    end
  end

  def unit_test_framework
    @manifest[:unit_test_framework]
  end

  def folder
    'katalogue' + '/' + @kata.name
  end

end


