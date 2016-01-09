
module TestDomainHelpers # mix-in

  module_function

  def dojo; @dojo ||= Dojo.new; end

  def languages; dojo.languages; end
  def exercises; dojo.exercises; end
  def katas;     dojo.katas;     end
  def caches;    dojo.caches;    end

  def history;   dojo.history;   end
  def runner;    dojo.runner;    end
  def shell;     dojo.shell;     end
  def log;       dojo.log;       end
  def git;       dojo.git;       end
  def disk;      dojo.disk;      end

  def dir_of(object); disk[history.path(object)]; end

  def make_kata(hash = {})
    hash[:id] ||= unique_id
    hash[:language] ||= 'C (clang)-assert'
    hash[:exercise] ||= 'Fizz_Buzz'
    language = languages[hash[:language]]
    exercise = exercises[hash[:exercise]]
    history.create_kata(language, exercise,hash[:id])
  end

  def unique_id
    hex_chars = "0123456789ABCDEF".split(//)
    Array.new(10) { hex_chars.sample }.shuffle.join
  end

end
