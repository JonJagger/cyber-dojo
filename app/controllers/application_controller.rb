
def rooted(path,filename); '../../' + path + '/' + filename;  end
def lib(filename);         rooted('lib',        filename); end
def app_lib(filename);     rooted('app/lib',    filename); end
def app_models(filename);  rooted('app/models', filename); end


def require_dependencies dir, dependencies
  dependencies.map{|f| File.join('..', '..', dir, f) }.each do |file_name|
      puts "Requiring dependency [#{file_name.inspect}]"
      require_dependency file_name
  end
end

require_dependencies 'lib', %w{Docker TestRunner DockerTestRunner DummyTestRunner HostTestRunner Folders Git OsDir OsDisk TimeNow UniqueId}
require_dependencies File.join("app", "lib"), %w{Approval Chooser Cleaner FileDeltaMaker GitDiff GitDiffBuilder GitDiffParser LineSplitter MakefileFilter OutputParser TdGapper}

#require_dependency app_lib('')
#require_dependency app_lib('')
#require_dependency app_lib('')
#require_dependency app_lib('')
#require_dependency app_lib('')
#require_dependency app_lib('')
#require_dependency app_lib('')
#require_dependency app_lib('')
#require_dependency app_lib('')
#require_dependency app_lib('')
#require_dependency app_lib('')

#require_dependency app_models('Avatar')
#require_dependency app_models('Avatars')
#require_dependency app_models('Dojo')
#require_dependency app_models('Exercise')
#require_dependency app_models('Exercises')
#require_dependency app_models('Kata')
#require_dependency app_models('Katas')
#require_dependency app_models('Language')
#require_dependency app_models('Languages')
#require_dependency app_models('Light')
#require_dependency app_models('Sandbox')
#require_dependency app_models('Tag')

class ApplicationController < ActionController::Base

  protect_from_forgery

  def id
    path = root_path
    path += 'test/cyberdojo/' if ENV['CYBERDOJO_TEST_ROOT_DIR']
    Folders::id_complete(path + 'katas/', params[:id]) || ''
  end

  def dojo
    externals = {
      :runner => runner,
      :disk   => disk,
      :git    => git
    }
    Dojo.new(root_path,externals)
  end

  def katas
    dojo.katas
  end

  def kata
    katas[id]
  end

  def avatars
    kata.avatars
  end

  def avatar_name
	params[:avatar]
  end

  def avatar
    avatars[avatar_name]
  end

  def root_path
    Rails.root.to_s + '/'
  end

private

  def runner
    @runner ||= Thread.current[:runner]
    @runner ||= DockerTestRunner.new if Docker.installed?
    @runner ||= HostTestRunner.new   if !ENV['CYBERDOJO_USE_HOST'].nil?
    @runner ||= DummyTestRunner.new
  end

  def disk
    @disk ||= Thread.current[:disk]
    @disk ||= OsDisk.new
  end

  def git
    @git ||= Thread.current[:git]
    @git ||= Git.new
  end

end
