CYBER_DOJO_ROOT = File.absolute_path(File.dirname(__FILE__) + '/../../')
# needed because app/lib/OsDisk requires app/lib/OsDir
$LOAD_PATH.unshift(CYBER_DOJO_ROOT + '/lib')

require 'JSON'
require CYBER_DOJO_ROOT + "/app/models/Avatar"
require CYBER_DOJO_ROOT + "/app/models/Dojo"
require CYBER_DOJO_ROOT + "/app/models/Kata"
require CYBER_DOJO_ROOT + "/app/models/Language"
require CYBER_DOJO_ROOT + "/app/models/Sandbox"
require CYBER_DOJO_ROOT + "/app/lib/OutputParser"
require CYBER_DOJO_ROOT + "/lib/OsDisk"
require CYBER_DOJO_ROOT + "/lib/Git"
require CYBER_DOJO_ROOT + "/lib/RawRunner"
require CYBER_DOJO_ROOT + "/lib/Uuid"

class OneLanguageChecker

  def initialize(root_path, option)
    @root_path = root_path
    if @root_path[-1] != '/'
      @root_path += '/'
    end
    @verbose = (option == 'noisy')
    @max_duration = 60
  end

  def check(
        language,
        installed_and_working = [ ],
        not_installed = [ ],
        installed_but_not_working = [ ]
    )
    @language = language
    @language_dir = @root_path + '/languages/' + language + "/"

    print "  #{language} " + ('.' * (35-language.to_s.length))

    @manifest_filename = @language_dir + 'manifest.json'
    @manifest = JSON.parse(IO.read(@manifest_filename))

    t1 = Time.now
    rag = red_amber_green
    t2 = Time.now
    print " #{rag.inspect} "
    took = ((t2 - t1) / 3).round(2)
    if rag == ['red','amber','green']
      installed_and_working << language
      print "installed and working"
    elsif rag == ['amber', 'amber', 'amber']
      not_installed << language
      print " not installed"
    else
      installed_but_not_working << language
      print "installed but not working"
    end
    print " (~ #{took} seconds)\n"
    took
  end

private

  def filename_42_exists?
    filename_42 != ""
  end

  def filename_42
    filenames = visible_filenames.select { |visible_filename|
      IO.read(@language_dir + visible_filename).include? '42'
    }
    if filenames == [ ]
      message = alert + " no 42-file"
      puts message
      return ""
    end
    if filenames.length > 1
      message = alert + " multiple 42-files " + filenames.inspect
      puts message
      return ""
    end
    print "."
    filenames[0]
  end

  def red_amber_green
    filename = filename_42
      red = language_test(filename, 'red', '42')
    amber = language_test(filename, 'amber', '4typo2')
    green = language_test(filename, 'green', '54')
    [ red, amber, green ]
  end

  def language_test(filename, expected_colour, replacement)
    kata = make_kata(@language, 'Yahtzee')
    avatar = kata.start_avatar
    visible_files = avatar.visible_files
    test_code = visible_files[filename]
    visible_files[filename] = test_code.sub('42', replacement)

    if @verbose
      puts "\n\n<test_code id='#{kata.id}' avatar='#{avatar.name}' colour='#{expected_colour}'>"
      puts visible_files[filename]
      puts "</test_code>"
    end

    delta = {
      :changed => [filename],
      :unchanged => visible_files.keys - [filename],
      :deleted => [ ],
      :new => [ ]
    }
    output = run_test(delta, avatar, visible_files, @max_duration)
    colour = avatar.traffic_lights.last['colour']

    if @verbose
      puts "<output>"
      puts output
      puts "</output>\n\n"
    end

    colour
  end

private

  def visible_filenames
    @manifest['visible_filenames'] || [ ]
  end

  def support_filenames
    @manifest['support_filenames'] || [ ]
  end

  def unit_test_framework
    @manifest['unit_test_framework'] || [ ]
  end

  def alert
    "\n>>>>>>>#{@language}<<<<<<<\n"
  end

private

  def dojo
    Thread.current[:disk]   ||= Disk.new
    Thread.current[:git]    ||= Git.new
    Thread.current[:runner] ||= RawRunner.new
    Dojo.new(@root_path,'json')
  end

  def make_kata(language_name, exercise_name)
    language = dojo.language(language_name)
    manifest = {
      :created => make_time(Time.now),
      :id => Uuid.new.to_s,
      :language => language.name,
      :exercise => exercise_name,
      :visible_files => language.visible_files,
      :unit_test_framework => language.unit_test_framework,
      :tab_size => language.tab_size
    }
    manifest[:visible_files]['output'] = ''
    manifest[:visible_files]['instructions'] = 'practice'
    dojo.create_kata(manifest)
  end

  def make_time(at)
    [at.year, at.month, at.day, at.hour, at.min, at.sec]
  end

  def run_test(delta, avatar, visible_files, timeout)
    avatar.sandbox.write(delta, visible_files)
    output = avatar.sandbox.test(timeout)
    traffic_light = OutputParser::parse(avatar.kata.language.unit_test_framework, output)
    avatar.save_traffic_light(traffic_light, make_time(Time.now))
    avatar.save_visible_files(visible_files)
    output
  end

end
