
require 'json'
require_relative '../../lib/all'
require_relative '../lib/all'
require_relative '../models/all'

def dojo
  Dojo.new
end

# - - - - - - - - - - - - - - - - - - - - - - - - -

def number(value,width)
  spaces = ' ' * (width - value.to_s.length)
  "#{spaces}#{value.to_s}"
end

def dots(dot_count)
  dots = '.' * (dot_count % 32)
  spaces = ' ' * (32 - dot_count % 32)
  dots + spaces + number(dot_count,5)
end

# - - - - - - - - - - - - - - - - - - - - - - - - -

class Dots
  def initialize(prompt)
    @count,@prompt = 0,prompt
  end
  def line
    if @count % 25 == 0
      @count += 1
      return "\r#{@prompt}" + dots
    else
      @count += 1
      return ''
    end
  end
private
  def dots
    n = 32 - @prompt.length
    dots = '.' * (@count % n)
    spaces = ' ' * (n - @count % n)
    dots + spaces + number(@count,5)
  end
end

# - - - - - - - - - - - - - - - - - - - - - - - - -

def mention(exceptions)
  if exceptions != [ ]
    puts
    puts
    puts "# #{exceptions.length} Exceptions saved in exceptions.log"
    `echo '#{exceptions.to_s}' > exceptions.log`
    puts
    puts
  end
end

# - - - - - - - - - - - - - - - - - - - - - - - - -

def refactoring_ids
  ids = []
  ids << 'E2285E5C2B'  # Yatzy C#-NUnit deer 9
  ids << '9D5B580C30'  # Yatzy Java-JUnit deer 9
  ids << '76DD58DE08'  # Yatzy C++-assert frog 18
  ids << '5C5B71C765'  # Yatzy Python-unittest hippo 42

  # http://coding-is-like-cooking.info/2013/01/setting-up-a-new-code-kata-in-cyber-dojo/
  ids << '672E047F5D'  # Tennis  C#-NUnit buffalo 11
  ids << '3367E4B0E9'  # Tennis  Ruby-TestUnit raccoon 4
  ids << 'B22DCD17C3'  # Tennis  Java-JUnit buffalo 13
  ids << 'A06DCDA217'  # Tennis  C++-assert wolf 7
  ids << '435E5C1C88'  # Tennis  Python-unittest moose 5
  ids
end

def refactoring_tar_filename
  'refactoring_dojos.tgz'
end
