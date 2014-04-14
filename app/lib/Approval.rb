require 'Folders'

module Approval

  def self.add_text_files_created_in_run_tests(test_run_dir, visible_files)
    txt_files = Folders.in(test_run_dir).select do |entry|
      entry.end_with?('.txt')
    end
    txt_files.each do |filename|
      visible_files[filename] = read_file(Pathname.new(test_run_dir).join(filename))
    end
  end

  def self.delete_text_files_deleted_in_run_tests(test_run_dir, visible_files)
    visible_files.delete_if do |filename, value|
      filename.end_with?('.txt') && !Folders.in(test_run_dir).include?(filename)
    end
  end

  def self.read_file(filename)
    # is this mapping necessary?
    File.open(filename, 'r') do |file|
      file.each_line.map{|line| line.gsub(/\r\n?/, "\n")}.join('')
    end
  end

end