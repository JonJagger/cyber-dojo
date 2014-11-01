
def rooted(path,filename); '../../' + path + '/' + filename;  end
def lib(filename);         rooted('lib',        filename); end
def app_lib(filename);     rooted('app/lib',    filename); end
def app_models(filename);  rooted('app/models', filename); end

require_dependency lib('Docker')
require_dependency lib('TestRunner')
require_dependency lib('DockerTestRunner')
require_dependency lib('DummyTestRunner')
require_dependency lib('HostTestRunner')
require_dependency lib('Folders')
require_dependency lib('Git')
require_dependency lib('OsDir')
require_dependency lib('OsDisk')
require_dependency lib('TimeNow')
require_dependency lib('UniqueId')

require_dependency app_lib('Approval')
require_dependency app_lib('Chooser')
require_dependency app_lib('Cleaner')
require_dependency app_lib('FileDeltaMaker')
require_dependency app_lib('GitDiff')
require_dependency app_lib('GitDiffBuilder')
require_dependency app_lib('GitDiffParser')
require_dependency app_lib('LineSplitter')
require_dependency app_lib('MakefileFilter')
require_dependency app_lib('OutputParser')
require_dependency app_lib('TdGapper')

require_dependency app_models('Avatar')
require_dependency app_models('Avatars')
require_dependency app_models('Dojo')
require_dependency app_models('Exercise')
require_dependency app_models('Exercises')
require_dependency app_models('Kata')
require_dependency app_models('Katas')
require_dependency app_models('Language')
require_dependency app_models('Languages')
require_dependency app_models('Light')
require_dependency app_models('Sandbox')
require_dependency app_models('Tag')

class ApplicationController < ActionController::Base

  protect_from_forgery

  def id
    path = root_path
    path += 'test/cyberdojo/' if ENV['CYBERDOJO_TEST_ROOT_DIR']
    Folders::id_complete(path + 'katas/', params[:id]) || ''
  end

  def dojo
    externals = {
      :runner => external[:runner],
      :disk   => external[:disk],
      :git    => external[:git]
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

  def external
    Thread.current
  end

end
