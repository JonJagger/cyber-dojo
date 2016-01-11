
module Runner # mix-in

  module_function

  # TODO: move this into host_disk_katas
  def katas_save(sandbox, delta, files)
    delta[:deleted].each do |filename|
      git.rm(path_of(sandbox), filename)
    end
    delta[:new].each do |filename|
      katas.write(sandbox, filename, files[filename])
      git.add(path_of(sandbox), filename)
    end
    delta[:changed].each do |filename|
      katas.write(sandbox, filename, files[filename])
    end
  end

  def output_or_timed_out(output, exit_status, max_seconds)
    exit_status != timed_out ? truncated(cleaned(output)) : did_not_complete(max_seconds)
  end

  def did_not_complete(max_seconds)
    "Unable to complete the tests in #{max_seconds} seconds.\n" +
    "Is there an accidental infinite loop?\n" +
    "Is the server very busy?\n" +
    "Please try again."
  end

  def timed_out
    (timeout = 128) + (kill = 9)
  end

  # TODO: drop this
  def path_of(obj)
    katas.path_of(obj)
  end

  include StringCleaner
  include StringTruncater
  include Redirect

end
