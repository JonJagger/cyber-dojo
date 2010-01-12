
class ExerciseModel

  def initialize(kata)
    @manifest = eval IO.read(kata.folder + '/' + 'kata_manifest.rb')
  end

  def visible_files
    manifest = eval IO.read(folder + '/' + 'exercise_manifest.rb')
    manifest[:visible_files].each do |filename,file|
      file[:content] = IO.read(folder + '/' + filename)
    end
    manifest[:visible_files]
  end

  def folder
    'kata_catalogue' + '/' + @manifest[:language] + '/' + @manifest[:exercise]
  end
   
end


