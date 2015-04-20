
require 'json'
require_relative '../lib/all'
require_relative '../app/lib/all'
require_relative '../app/models/all'

def create_dojo
  load '../config/initializers/cyber_dojo.rb'
  Dojo.new
end

def number(value,width)
  spaces = ' ' * (width - value.to_s.length)
  "#{spaces}#{value.to_s}"
end

def dots(dot_count)
  dots = '.' * (dot_count % 32)
  spaces = ' ' * (32 - dot_count % 32)
  dots + spaces + number(dot_count,5)
end

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
