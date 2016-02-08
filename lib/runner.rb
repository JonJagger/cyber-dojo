
module Runner # mix-in

  module_function

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

  def write_files(tmp_path, files)
    dir = disk[tmp_path]
    dir.make
    files.each { |filename, content| dir.write(filename, content) }
    shell.exec("chown -R #{user}:#{user} #{tmp_path}")
  end

  def unique_tmp_path
    uuid = Array.new(10) { hex_chars.sample }.shuffle.join
    '/tmp/cyber-dojo-' + uuid + '/'
  end

  def hex_chars
    "0123456789ABCDEF".split(//)
  end

  def user
    # see comments in languages/alpine_base/_docker_context/Dockerfile
    'www-data'
  end

  include StringCleaner
  include StringTruncater
  include StderrRedirect

end
