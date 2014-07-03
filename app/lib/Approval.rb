
module Approval

  def self.add_created_txt_files(test_run_dir, visible_files)
    txt_files = self.in(test_run_dir).select do |entry|
      entry != '.' && entry != '..' && entry.end_with?('.txt')
    end
    txt_files.each do |filename|
      pathed_filename = Pathname.new(test_run_dir).join(filename)
      visible_files[filename] = read_file(pathed_filename)
    end
  end

  def self.remove_deleted_txt_files(test_run_dir, visible_files)
    visible_files.delete_if do |filename, value|
      filename.end_with?('.txt') && !self.in(test_run_dir).include?(filename)
    end
  end

  def self.read_file(filename)
    # is this mapping necessary?
    File.open(filename, 'r') do |file|
      file.each_line.map{|line| line.gsub(/\r\n?/, "\n")}.join('')
    end
  end

  def self.in(path)
    Dir.entries(path).select { |name| name != '.' and name != '..' }
  end

end