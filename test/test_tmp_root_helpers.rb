
module TestTmpRootHelpers # mix-in

  module_function

  def tmp_root
    '/tmp/cyber-dojo/'
  end

  def setup_tmp_root
    # the Teardown-Before-Setup pattern gives good diagnostic info if
    # a test fails but these backtick command mean the tests cannot be
    # run in parallel...
    success = 0

    command = "rm -rf #{tmp_root}"
    output = `#{command}`
    exit_status = $?.exitstatus
    puts "#{command}\n\t->#{output}\n\t->#{exit_status}" unless exit_status == success

    command = "mkdir -p #{tmp_root}"
    output = `#{command}`
    exit_status = $?.exitstatus
    puts "#{command}\n\t->#{output}\n\t->#{exit_status}" unless exit_status == success
  end

end
