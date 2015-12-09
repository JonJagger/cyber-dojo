
module TestDomainHelpers # mix-in

  module_function

  def dojo; @dojo ||= Dojo.new; end

  def languages; dojo.languages; end
  def exercises; dojo.exercises; end
  def katas;     dojo.katas;     end
  def caches;    dojo.caches;    end

  def one_self;  dojo.one_self;  end
  def starter;   dojo.starter;   end
  def runner;    dojo.runner;    end
  def shell;     dojo.shell;     end
  def log;       dojo.log;       end
  def git;       dojo.git;       end
  def disk;      dojo.disk;      end

  include UniqueId

  def dir_of(object); disk[object.path]; end

  def make_kata(id = unique_id, language_name = 'C (clang)-assert', exercise_name = 'Fizz_Buzz')
    language = languages[language_name]
    exercise = exercises[exercise_name]
    katas.create_kata(language, exercise, id)
  end

end
