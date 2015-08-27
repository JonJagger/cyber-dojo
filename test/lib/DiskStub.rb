
class DiskStub

  def initialize
    @stub = DiskFake.new
    cache = JSON.parse(File.read("#{File.dirname(__FILE__)}/disk_stub_cache.json"))
    cache.each do |path,content| 
      dir_name,file_name = File.split(path)
      @stub[dir_name].write_raw(file_name,content)
    end
  end

  def method_missing(sym, *args, &block)
    @stub.send(sym, *args, &block)
  end
  
end
