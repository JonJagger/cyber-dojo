
def rooted(path,filename); '../' + path + '/' + filename;  end
def lib(filename);         rooted('lib',        filename); end
def app_helpers(filename); rooted('app/helpers',filename); end
def app_lib(filename);     rooted('app/lib',    filename); end
def app_models(filename);  rooted('app/models', filename); end
def test_lib(filename);    rooted('test/lib',   filename); end

require 'json'

require_relative lib('Docker')
require_relative lib('HostTestRunner')
require_relative lib('DockerTestRunner')
require_relative lib('DummyTestRunner')
require_relative lib('Folders')
require_relative lib('Git')
require_relative lib('Disk')
require_relative lib('OsDir')
require_relative lib('OsDisk')
require_relative lib('FakeDisk')
require_relative lib('FakeDir')
require_relative lib('TestRunner')
require_relative lib('TimeNow')
require_relative lib('UniqueId')

require_relative app_helpers('avatar_image_helper')
require_relative app_helpers('logo_image_helper')
require_relative app_helpers('parity_helper')
require_relative app_helpers('pie_chart_helper')
require_relative app_helpers('traffic_light_helper')

require_relative app_lib('Approval')
require_relative app_lib('Chooser')
require_relative app_lib('Cleaner')
require_relative app_lib('FileDeltaMaker')
require_relative app_lib('GitDiff')
require_relative app_lib('GitDiffBuilder')
require_relative app_lib('GitDiffParser')
require_relative app_lib('LineSplitter')
require_relative app_lib('MakefileFilter')
require_relative app_lib('OutputParser')
require_relative app_lib('TdGapper')

require_relative app_models('Avatar')
require_relative app_models('Avatars')
require_relative app_models('Dojo')
require_relative app_models('Exercise')
require_relative app_models('Exercises')
require_relative app_models('Kata')
require_relative app_models('Katas')
require_relative app_models('Language')
require_relative app_models('Languages')
require_relative app_models('Light')
require_relative app_models('Sandbox')
require_relative app_models('Tag')

require_relative test_lib('DummyGit')
require_relative test_lib('SpyDir')
require_relative test_lib('SpyDisk')
require_relative test_lib('SpyGit')
require_relative test_lib('StubTestRunner')
