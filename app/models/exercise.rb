
class Exercise

  def initialize(kata)
    @kata = kata
  end

  def visible_files
    manifest = eval IO.read(folder + '/' + 'exercise_manifest.rb')
    manifest[:visible_files].each do |filename,file|
      file[:content] = IO.read(folder + '/' + filename)
    end
    manifest[:visible_files]
  end

  def folder
    'kata_catalogue' + '/' + @kata.language + '/' + @kata.exercise_name
  end
   
end


