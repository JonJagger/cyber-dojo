
module TestDomainHelpers # mix-in

  module_function

  def dojo; @dojo ||= Dojo.new; end

  def languages; dojo.languages; end
  def exercises; dojo.exercises; end
  def runner;    dojo.runner;    end
  def katas;     dojo.katas;     end
  def shell;     dojo.shell;     end
  def disk;      dojo.disk;      end
  def log;       dojo.log;       end
  def git;       dojo.git;       end

  def make_kata(hash = {})
    hash[:id] ||= unique_id
    hash[:language] ||= default_language_name
    hash[:exercise] ||= default_exercise_name
    language = languages[hash[:language]]
    exercise = exercises[hash[:exercise]]
    katas.create_kata(language, exercise, hash[:id])
  end

  def unique_id
    hex_chars = "0123456789ABCDEF".split(//)
    Array.new(10) { hex_chars.sample }.shuffle.join
  end

  def default_language_name
    'C (clang)-assert'
  end

  def default_exercise_name
    'Fizz_Buzz'
  end

end
