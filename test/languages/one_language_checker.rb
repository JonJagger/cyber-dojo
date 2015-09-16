
require_relative '../all'
require_relative '../TestDomainHelpers'
require_relative '../TestExternalHelpers'

class OneLanguageChecker

  include TestDomainHelpers
  include TestExternalHelpers

  def initialize(verbose)
    @verbose = verbose
  end
  
  def check(name,test,verbose=false)
    language_name = [name,test].join('-')
    @language = languages[language_name]
    if true #@language.runnable?
      vputs "  #{language_name} " + ('.' * (35-language_name.to_s.length))
      t1 = Time.now
      rag = red_amber_green
      t2 = Time.now
      took = ((t2 - t1) / 3).round(2)
      vputs " (~ #{took} seconds)\n"
      rag
    else
      vputs " #{language_name} is not runnable"
    end
  end

private

  include TimeNow

  def red_amber_green
    # creates a new *dojo* for each red/amber/green
    [:red,:amber,:green].map{ |colour|
      begin
        language_test(colour)
      rescue Exception => e
        e.message
      end
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def language_test(colour)
    exercise = exercises['Fizz_Buzz']
    kata = katas.create_kata(@language, exercise)
    avatar = kata.start_avatar

    pattern = pattern_6times9

    filename = filename_6times9(pattern[:red])
    from = pattern[:red]
    to = pattern[colour]

    # Cucumber tests special case handling
    if @language.name === 'Java-Cucumber' && colour === :amber
      filename = 'Hiker.java'
      from = '}'
      to = '}typo'
    end

    visible_files = @language.visible_files
    test_code = visible_files[filename]
    visible_files[filename] = test_code.sub(from, to)

    vputs [
      "<test_code id='#{kata.id}' avatar='#{avatar.name}' expected_colour='#{colour}'>",
      visible_files[filename],
      "</test_code>"
    ].join("\n")

    delta = {
      :changed => [filename],
      :unchanged => visible_files.keys - [filename],
      :deleted => [ ],
      :new => [ ]
    }

    now = time_now
    limit = 60
    traffic_lights,_,_ = avatar.test(delta, visible_files, now, limit)

    vputs [
      "<output>",
      visible_files['output'],
      "</output>"
    ].join("\n")

    rag = traffic_lights.last['colour']

    vputs [
      "<test_code actual_colour='#{rag}'>",
      "</test_code>"
    ].join("\n")

    print '.'
    rag
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def pattern_6times9
    case (@language.name)
      when 'Clojure-.test'
        then make_pattern('* 6 9')
      when 'Java-Cucumber',
           'Ruby-Cucumber'
        then make_pattern('6 times 9')
      when 'Java-Mockito',
           'Java-PowerMockito'
        then make_pattern('thenReturn(9)')
      when 'Asm-assert'
        then make_pattern('mov ebx, 9')
      else
        make_pattern('6 * 9')
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def make_pattern(base)
    { :red => base,
      :amber => base.sub('9', '9typo'),
      :green => base.sub('9', '7')
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def filename_6times9(pattern)
    filenames = @language.visible_filenames.select { |visible_filename|
      IO.read(@language.path + visible_filename).include? pattern
    }
    if filenames == [ ]
      message = " no '#{pattern}' file found"
      vputs alert + message
      raise message
    end
    if filenames.length > 1
      message = " multiple '#{pattern}' files " + filenames.inspect
      vputs alert + message
      raise message
    end
    vputs "."
    filenames[0]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def alert
    "\n>>>#{@language.name}<<\n"
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def vputs(message)
    puts message if @verbose
  end

end
