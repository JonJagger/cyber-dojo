require 'pathname'

module Approval

=begin
  def add_created_txt_files(dir, visible_files)
    txt_files = dir.each_file.select do |entry|
      entry.end_with?('.txt')
    end
    txt_files.each do |filename|
      visible_files[filename] = dir.read(filename)
    end
  end

  def remove_deleted_txt_files(dir, visible_files)
    all_files = dir.each_file.entries
    visible_files.delete_if do |filename, value|
      filename.end_with?('.txt') && !all_files.include?(filename)
    end
  end

  #def read_file(filename)
  #  # is this mapping necessary?
  #  File.open(filename, 'r') do |file|
  #    file.each_line.map{|line| line.gsub(/\r\n?/, "\n")}.join('')
  #  end
  #end

  #def all_in(path)
  #  Dir.entries(path).select { |name| !dotted?(name) }
  #end

  #def dotted?(name)
  #  name === '.' || name === '..'
  #end
=end

end