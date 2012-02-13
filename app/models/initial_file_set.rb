
# > ruby test/functional/initial_file_set_tests.rb

class InitialFileSet
  
  def initialize(manifest_pathname)
    @manifest = eval IO.read(manifest_pathname)
    @dir = File.dirname(manifest_pathname)
  end
  
  def copy_hidden_files_to(folder)
    hidden_filenames.each do |hidden_filename|
      system("ln '#{@dir}/#{hidden_filename}' '#{folder}/#{hidden_filename}'")
    end
  end

  def visible_files
    @manifest[:visible_filenames].inject({}) do |result,filename|
      result.merge( { filename, IO.read("#{@dir}/#{filename}") } )
    end
  end
  
private

  def hidden_filenames
    @manifest[:hidden_filenames] || [ ]
  end

end
