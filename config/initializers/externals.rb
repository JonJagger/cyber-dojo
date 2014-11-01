
# set the externals here

def rooted(path,filename); '../../' + path + '/' + filename;  end

def lib(filename); rooted('lib', filename); end

require_relative lib('Docker')
require_relative lib('HostTestRunner')
require_relative lib('DockerTestRunner')
require_relative lib('DummyTestRunner')
require_relative lib('Git')
require_relative lib('OsDisk')

def set_all_externals
  external[:runner] = choose_test_runner
  external[:disk] = OsDisk.new
  external[:git] = Git.new
end

def choose_test_runner
  return DockerTestRunner.new if Docker.installed?
  return HostTestRunner.new   if !ENV['CYBERDOJO_USE_HOST'].nil?
  return DummyTestRunner.new
end

def external
  Thread.current
end

set_all_externals
