
module TestTmpRootHelpers # mix-in

  module_function

  def tmp_key
    'CYBER_DOJO_TMP_ROOT'
  end

  def tmp_root
    root = ENV[tmp_key]
    fail RuntimeError.new("ENV['#{tmp_key}'] not exported") if root.nil?
    root.end_with?('/') ? root : (root + '/')
  end

  def check_tmp_root_exists
    FileUtils.mkdir_p(tmp_root)
    fail RuntimeError.new("#{tmp_root} does not exist") unless File.directory?(tmp_root)
  end

end
