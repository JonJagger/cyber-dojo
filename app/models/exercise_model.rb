
class ExerciseModel

  def initialize(kata)
    @manifest = eval IO.read(kata.folder + '/' + 'kata_manifest.rb')
    @exercise = eval IO.read(folder + '/' + 'exercise_manifest.rb')
  end

  def language
    @exercise[:language]
  end

  def unit_test_framework
    @exercise[:unit_test_framework]
  end

  def name
    @manifest[:exercise]
  end

  def initial_files
    @exercise[:visible_files].each do |filename,file|
      file[:content] = IO.read(folder + '/' + filename)
    end
    @exercise[:visible_files]
  end

  #def filenames
  #  [@exercise[:visible_files], @exercise[:hidden_files], folder]
  #end

  def max_run_tests_duration
    @exercise[:max_run_tests_duration]
  end
   
  def folder
    'kata_catalogue' + '/' + @manifest[:language] + '/' + @manifest[:exercise]
  end

end


