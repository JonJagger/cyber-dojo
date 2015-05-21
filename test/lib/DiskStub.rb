
class DiskStub

  def initialize(dojo=nil)
    @stub = DiskFake.new
    @stub['/var/www/cyber-dojo/katas'].make
    
    cache = JSON.parse(File.read('/var/www/cyber-dojo/test/disk_cache.json'))
    cache.each do |path,content| 
      dir_name,file_name = File.split(path)
      @stub[dir_name].write_raw(file_name,content)
    end
  end

  def method_missing(sym, *args, &block)
    @stub.send(sym, *args, &block)
  end
  
end
