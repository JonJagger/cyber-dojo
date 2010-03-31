
class Exercise # rename KataFiles

  def initialize(kata)
    @kata = kata
    @manifest = eval IO.read(folder + '/' + 'manifest.rb')
  end

  def visible_files # visible
    @manifest[:visible_files].each do |filename,file|
      file[:content] = IO.read(folder + '/' + filename)
    end
    @manifest[:visible_files]
  end

  def hidden_files # hidden
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


