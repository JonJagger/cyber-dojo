
class Caches

  def initialize(dojo, path)
    @parent = dojo
    @path = path
    @path += '/' unless @path.end_with? '/'
  end

  attr_reader :path

  include ExternalParentChain

  send :public, :write_json, :read_json

end
