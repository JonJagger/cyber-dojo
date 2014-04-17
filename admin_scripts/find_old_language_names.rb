
# How do I set dirs that ruby will look in to resolve requires?

ROOT_DIR = File.dirname(__FILE__) + '/../'
require ROOT_DIR + '/app/lib/DockerRunner'
require ROOT_DIR + '/app/lib/LinuxPaas'
require ROOT_DIR + '/app/lib/RawRunner'
require ROOT_DIR + '/lib/Folders'
require ROOT_DIR + '/lib/Git'
require ROOT_DIR + '/lib/OsDir'
require ROOT_DIR + '/lib/OsDisk'

disk = OsDisk.new
git = Git.new
runner = DockerRunner.new
paas = LinuxPaas.new(disk, git, runner)
format = 'json'
dojo = paas.create_dojo(ROOT_DIR, format)

languages = dojo.languages.each.entries

p languages.inspect
