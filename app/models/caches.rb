
class Caches

  def initialize(dojo)
    @parent = dojo
    @path = slashed(dojo.env('caches', 'root'))
  end

  attr_reader :path, :parent

  def write_json_once(filename)
    File.open(path + filename, File::WRONLY|File::CREAT|File::EXCL, 0644) do |fd|
      fd.write(JSON.unparse(yield)) # yield must return a json object
    end
  rescue Errno::EEXIST
  end

  private

  include ExternalParentChainer
  include ExternalDir
  include Slashed

  send :public, :exists?, :write_json, :read_json

end

# The caches object represents the caches folder.
# It holds cache files for the languages, exercises, and runner.
# The primary reason for having caches is to speed up setup and test.
# Without caches to determine which languages to display at setup
# cyber-dojo would need to read *each* language+tests manifest.json
# file to determine its docker image_name and then see if the
# runner could run it.
