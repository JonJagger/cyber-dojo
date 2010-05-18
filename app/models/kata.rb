
class Kata

  def initialize(dojo, id, name = "", readonly = false)
    @dojo = dojo
    @id = id
    @manifest = eval IO.read(folder + '/' + 'kata_manifest.rb')
    @file_set = KataFileSet.new(self)
    @avatar = Avatar.new(self, name) if name != ""
    @readonly = readonly
  end

  def id
    @id.to_s
  end

  def readonly
    @readonly
  end

  def name
    @manifest[:kata_name].to_s
  end

  def max_run_tests_duration
    @manifest[:max_run_tests_duration].to_i
  end

  def unit_test_framework
    @file_set.unit_test_framework
  end

  def file_set
    @file_set
  end

  def avatar
    @avatar
  end

  def avatars
    result = []
    Avatar.names.each do |avatar_name|
      path = folder + '/' + avatar_name
      result << Avatar.new(self, avatar_name) if File.exists?(path)
    end
    result
  end

  def run_tests(manifest)
    File.open(folder, 'r') do |f|
      flock(f) do |lock|
        run_tests_output = TestRunner.run_tests(self, manifest)
        test_info = RunTestsOutputParser.new().parse(self, run_tests_output)
        avatar.save(manifest, test_info)
      end
    end
  end

  def folder
    @dojo.folder + '/' + id
  end

end


