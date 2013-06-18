require 'Folders'

module Approval
  
  def self.add_new_text_files_created_in_run_tests(test_run_dir, visible_files)
    txt_files = Folders.in(test_run_dir).select do |entry|
      entry.end_with?('.txt')
    end
    txt_files.each do |filename|
      visible_files[filename] = read_file(Pathname.new(test_run_dir).join(filename))
    end
  end

  def self.delete_text_files_deleted_in_run_tests(test_run_dir, visible_files)
    visible_files.delete_if do |filename, value| 
      filename.end_with?(".txt") and not Folders.in(test_run_dir).include?(filename)
    end
  end

  def self.read_file(filename)
    data = ''
    f = File.open(filename, "r")
    f.each_line do |line|
      line = line.gsub /\r\n?/, "\n"
      data += line
    end
    f.close()
    return data
  end

end