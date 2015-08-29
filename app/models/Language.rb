# See comments at end of file

class Language

  include ExternalParentChain

  def initialize(languages,dir_name,test_dir_name,display_name=nil)
    @parent,@dir_name,@test_dir_name,@display_name = languages,dir_name,test_dir_name,display_name
  end

  attr_reader :dir_name, :test_dir_name

  def path
    @parent.path + dir_name + '/' + test_dir_name + '/'
  end

  def name    
    display_name.split(',').map{ |s| s.strip }.join('-')
  end

  def display_name
    @display_name ||= manifest_property
  end

  def exists?
    dir.exists?(manifest_filename)
  end

  def runnable?
    runner.runnable?(self)
  end

  def image_name
    manifest_property
  end

  def unit_test_framework
    manifest_property
  end

  def display_test_name
    manifest_property || unit_test_framework
  end

  def filename_extension
    manifest_property || ''
  end

  def visible_filenames
    manifest_property || [ ]
  end

  def visible_files
    Hash[visible_filenames.collect{ |filename|
      [ filename, read(filename) ]
    }]
  end

  def support_filenames
    manifest_property || [ ]
  end

  def highlight_filenames
    manifest_property || [ ]
  end

  def progress_regexs
    manifest_property || [ ]
  end

  def tab_size
    manifest_property || 4
  end

  def tab
    " " * tab_size
  end

  def lowlight_filenames
    if !highlight_filenames.empty?
      return visible_filenames - highlight_filenames
    else
      return ['cyber-dojo.sh', 'makefile', 'Makefile', 'unity.license.txt']
    end
  end

  def colour(output)
    OutputColour.of(unit_test_framework, output)
  end

  def filter(filename,content)
    # Cater for app/assets/javascripts/jquery-tabby.js plugin
    # See app/lib/MakefileFilter.rb 
    MakefileFilter.filter(filename, content)
  end

  def after_test(output,files)
    content = files['cyber-dojo.sh']
    #TODO: !content.nil? is because test/app_model/avatar_tests.rb are poor
    #      and have interactions with no cyber-dojo.sh file
    if !content.nil? && !content.include?(cyber_dojo_sh) && !content.include?(commented_cyber_dojo_sh)
      separator = "\n\n"
      output = [
        'ALERT: your cyber-dojo.sh differs from the master cyber-dojo.sh.',
        'ALERT:  - the master has been appended (in comments) to your cyber-dojo.sh.',
        'ALERT:  - please examine cyber-dojo.sh carefully'
      ].join("\n") + separator + output
      files['cyber-dojo.sh'] = content.rstrip + separator + commented_cyber_dojo_sh
    end
    output
  end

private

  include ManifestProperty

  def cyber_dojo_sh
    visible_files['cyber-dojo.sh']
  end

  def commented_cyber_dojo_sh
    cyber_dojo_sh.split("\n").map{|line| '# ' + line}.join("\n")
  end

  def manifest
    begin
      @manifest ||= JSON.parse(read(manifest_filename))
    rescue Exception => e
      message =  "JSON.parse(#{manifest_filename}) exception" + "\n" +
        "language: " + path + "\n" +
        " message: " + e.message
      raise message
    end
  end

  def manifest_filename
    'manifest.json'
  end

  def read(filename)
    dir.read(filename)
  end

end

# - - - - - - - - - - - - - - - - - - - -
# lowlight_filenames
# - - - - - - - - - - - - - - - - - - - -
# Caters for two uses
# 1. carefully constructed set of start files
#    (like James Grenning uses)
#    with explicitly set highlight_filenames entry 
#    in manifest
# 2. default set of files direct from languages/
#    viz, no highlight_filenames entry in manifest
# - - - - - - - - - - - - - - - - - - - -

