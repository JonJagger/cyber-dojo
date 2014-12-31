
me = File.expand_path(File.dirname(__FILE__))
CYBERDOJO_HOME_DIR = File.expand_path('..', me) + '/'

$LOAD_PATH << CYBERDOJO_HOME_DIR + 'lib'
$LOAD_PATH << CYBERDOJO_HOME_DIR + 'app/lib'
$LOAD_PATH << CYBERDOJO_HOME_DIR + 'app/models'

def require_filenames(filenames)
  filenames.each {|filename| require filename}
end

require_filenames %w{
  Cleaner UniqueId TimeNow
  Disk Dir
  Git GitDiff
  Docker
  DockerTestRunner DummyTestRunner
  Externals
  Dojo
  Languages Language
  Exercises Exercise
  Katas Kata
  Avatars Avatar
  Sandbox Light Tag
}

require 'json'

def create_dojo
  thread = Thread.current
  thread[:disk] = Disk.new
  thread[:git] = Git.new
  thread[:runner] = DockerTestRunner.new
  Dojo.new(CYBERDOJO_HOME_DIR)
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
