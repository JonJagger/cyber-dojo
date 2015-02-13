
require_relative '../test_coverage'
require_relative '../all'
require_relative '../test_base'

class ModelTestBase < TestBase

  include ExternalSetter

  include ExternalDiskDir
  include ExternalGit
  include ExternalRunner
  include ExternalExercisesPath
  include ExternalLanguagesPath
  include ExternalKatasPath

  include UniqueId

  def setup
    reset_external(:disk, DiskFake.new)
    reset_external(:git, GitSpy.new)
    reset_external(:runner, TestRunnerStub.new)
    reset_external(:exercises_path, 'exercises/')
    reset_external(:languages_path, 'languages/')
    reset_external(:katas_path, 'katas/')
    @dojo = Dojo.new
    @max_duration = 15
  end

  def make_kata(id = unique_id)
    visible_files = {
        'wibble.hpp' => '#include <iostream>',
        'wibble.cpp' => '#include "wibble.hpp"'
    }
    language = @dojo.languages['test-C++-Catch']
    language.dir.write('manifest.json', { :visible_filenames => visible_files.keys })
    visible_files.each { |filename,content| language.dir.write(filename, content) }
    exercise = @dojo.exercises['test_Yahtzee']
    exercise.dir.write('instructions', 'your task...')
    @dojo.katas.create_kata(language, exercise, id)
  end

  def path_ends_in_slash?(object)
    object.path.end_with?(disk.dir_separator)
  end

  def path_has_adjacent_separators?(object)
    doubled_separator = disk.dir_separator * 2
    object.path.scan(doubled_separator).length > 0
  end

end
