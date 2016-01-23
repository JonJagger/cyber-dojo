
class Caches

  def initialize(dojo)
    @dojo = dojo
    @path = config['root']['caches']
  end

  def path
    slashed(@path)
  end

  def parent
    @dojo
  end

  private

  include ExternalParentChainer
  include ExternalDir
  include Slashed

  send :public, :exists?, :write_json, :read_json

end

# The caches object represents the dir holding the caches
# for the languages, exercises, and runners.
# The primary reason for having caches is the setup page.
# Without caches to determine which languages to display
# cyber-dojo would need to read *each* language+tests manifest.json
# file to determine its docker image_name and then see if the
# runner could run it.
# Caches are created by the caches/refresh_all.sh script
# which is called from admin_scripts/pull.sh
# Once a cyber-dojo server is running caches is read-only.
