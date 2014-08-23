
require_relative '../all'

class OneLanguageChecker

  def initialize(root_path, option)
    @root_path = root_path
    @verbose = (option == 'noisy')
    @max_duration = 60
  end

  def check(language)
    @language = language
    @language_dir = @root_path + 'languages/' + language + '/'

    vputs "  #{language} " + ('.' * (35-language.to_s.length))

    @manifest_filename = @language_dir + 'manifest.json'
    @manifest = JSON.parse(IO.read(@manifest_filename))

    t1 = Time.now
    rag = red_amber_green
    t2 = Time.now
    took = ((t2 - t1) / 3).round(2)
    vputs " (~ #{took} seconds)\n"
    rag
  end

private

  def filename_6times9_exists?
    filename_6times9 != ""
  end

  def filename_6times9
    filenames = visible_filenames.select { |visible_filename|
      IO.read(@language_dir + visible_filename).include? '6 * 9'
    }
    if filenames == [ ]
      # If any found hard-code the correct 6*9 file
      message = alert + " no '6 * 9' file found"
      vputs message
      return ""
    end
    if filenames.length > 1
      message = alert + " multiple '6 * 9' files " + filenames.inspect
      vputs message
      return ""
    end
    vputs "."
    filenames[0]
  end

  def red_amber_green
    filename = filename_6times9
      red = language_test(filename, 'red', '6 * 9')
    amber = language_test(filename, 'amber', '6typo * 9typo')
    green = language_test(filename, 'green', '6 * 7')
    [ red, amber, green ]
  end

  def language_test(filename, expected_colour, replacement)

    # NB: This works by creating a new kata for each
    #     red/amber/green test. This is needlessly slow.
    #     Just make one kata, and then verify
    #     o) its starts tests red
    #     o) s/6*9/6*7/ tests green
    #     o) s/6*9/s345 * 9345/ tests amber

    kata = make_kata(@language, 'Fizz_Buzz')
    avatar = kata.start_avatar
    visible_files = avatar.visible_files
    test_code = visible_files[filename]
    visible_files[filename] = test_code.sub('6 * 9', replacement)

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

    traffic_lights,new_files,filenames_to_delete =
      avatar.test(delta, visible_files, time_now, @max_duration)

    colour = avatar.traffic_lights.last['colour']

    vputs [
      "<output>",
      visible_files['output'],
      "</output>"
    ].join("\n")

    colour
  end

private

  def visible_filenames
    @manifest['visible_filenames'] || [ ]
  end

  def alert
    "\n>>>#{@language}<<\n"
  end

private

  def vputs(message)
    puts message if @verbose
  end

  def dojo
    externals = {
      :disk => Disk.new,
      :git => Git.new,
      :runner => HostRunner.new
    }
    ENV['CYBERDOJO_TEST_ROOT_DIR'] = 'true'
    Dojo.new(@root_path,externals)
  end

  def make_kata(language_name, exercise_name)
    language = dojo.languages[language_name]
    exercise = dojo.exercises[exercise_name]
    dojo.katas.create_kata(language, exercise)
  end

end
