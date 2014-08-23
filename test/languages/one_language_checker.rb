
require_relative '../all'

class OneLanguageChecker

  def initialize(root_path, option)
    ENV['CYBERDOJO_TEST_ROOT_DIR'] = 'true'
    @root_path = root_path
    @verbose = (option == 'noisy')
  end

  def check(language_name)
    # if running on a Docker server, returns [red,amber,green] state
    # else returns nil
    @language = dojo.languages[language_name]
    if @language.runnable?
      vputs "  #{language_name} " + ('.' * (35-language_name.to_s.length))
      t1 = Time.now
      rag = red_amber_green
      t2 = Time.now
      took = ((t2 - t1) / 3).round(2)
      vputs " (~ #{took} seconds)\n"
      rag
    end
  end

private

  def pattern_6times9
    # Hard-code 6*9 pattern for special cases
    if @language.name == 'Clojure-.test'
      return {
        :red => '* 6 9',
        :amber => '* 6 9typo',
        :green => '* 6 7'
      }
    end
    if @language.name == 'Java-1.8_Cucumber'
      return {
        :red => '6 times 9',
        :amber => '6 times 9typo',
        :green => '6 times 7'
      }
    end
    if @language.name == 'Java-1.8_Mockito' || @language.name == 'Java-1.8_Powermockito'
      return {
        :red => 'thenReturn(9)',
        :amber => 'thenReturn(9typo)',
        :green => 'thenReturn(7)'
      }
    end

    { :red => '6 * 9',
      :amber => '6 * 9typo',
      :green => '6 * 7'
    }
  end

  def red_amber_green
    pattern = pattern_6times9
    filename = filename_6times9(pattern[:red])
      red = language_test(filename, 'red',   pattern[:red], pattern[:red])
    amber = language_test(filename, 'amber', pattern[:red], pattern[:amber])
    green = language_test(filename, 'green', pattern[:red], pattern[:green])
    [ red, amber, green ]
  end

  def language_test(filename, expected_colour, from, to)
    # NB: This works by creating a new kata for each
    #     red/amber/green test. This is needlessly slow.
    #     Just make one kata, and then verify
    #     o) its starts tests red
    #     o) s/6*9/6*7/ tests green
    #     o) s/6*9/s345 * 9345/ tests amber
    exercise = dojo.exercises['Fizz_Buzz']
    kata = dojo.katas.create_kata(@language, exercise)
    avatar = kata.start_avatar
    visible_files = @language.visible_files
    test_code = visible_files[filename]
    visible_files[filename] = test_code.sub(from, to)

    vputs [
      "<test_code id='#{kata.id}' avatar='#{avatar.name}' colour='#{expected_colour}'>",
      visible_files[filename],
      "</test_code>"
    ].join("\n")

    delta = {
      :changed => [filename],
      :unchanged => visible_files.keys - [filename],
      :deleted => [ ],
      :new => [ ]
    }

    traffic_lights,_,_ = avatar.test(delta, visible_files)
    colour = traffic_lights.last['colour']

    vputs [
      "<output>",
      visible_files['output'],
      "</output>"
    ].join("\n")

    colour
  end

  #- - - - - - - - - - - - - - - - - - - - -

  def filename_6times9(pattern)
    filenames = @language.visible_filenames.select { |visible_filename|
      IO.read(@language.path + visible_filename).include? pattern
    }
    if filenames == [ ]
      message = alert + " no '#{pattern}' file found"
      vputs message
      return ""
    end
    if filenames.length > 1
      message = alert + " multiple '#{pattern}' files " + filenames.inspect
      vputs message
      return ""
    end
    vputs "."
    filenames[0]
  end

  def alert
    "\n>>>#{@language.name}<<\n"
  end

  def vputs(message)
    puts message if @verbose
  end

  def externals
    {
      :disk => OsDisk.new,
      :git => Git.new,
      :runner => runner
    }
  end

  def runner
    if Docker.installed?
      DockerTestRunner.new
    else
      DummyTestRunner.new
    end
  end

  def dojo
    Dojo.new(@root_path,externals)
  end

end
