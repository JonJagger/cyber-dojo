
class KataFileSet

  def initialize(kata)
    @kata = kata
    @manifest = eval IO.read(folder + '/' + 'manifest.rb')
  end

  def visible
    @manifest[:visible_files].each do |filename,file|
      file[:content] = IO.read(folder + '/' + filename)
    end
    @manifest[:visible_files]
  end

  def hidden
    if @manifest[:hidden_files]
      @manifest[:hidden_files]
    else
      {}
    end
  end

  def unit_test_framework
    @manifest[:unit_test_framework]
  end

  def folder
    'katalogue' + '/' + @kata.name
  end

end


