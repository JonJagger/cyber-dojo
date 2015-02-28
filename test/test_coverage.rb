require 'simplecov'

module SimpleCov::Configuration
  def clean_filters
    @filters = [ ]
  end
end

SimpleCov.start do
  add_filter '/ruby-1.9.3-p125/'
  add_filter '/ruby-2.1.3p242'
  add_filter '/cyberdojo/config/'

  add_group 'admin_scripts',   'admin_scripts'
  add_group 'app/controllers', 'app/controllers'
  add_group 'app/models',      'app/models'
  add_group 'app/helpers',     'app/helpers'
  add_group 'app/lib',         'app/lib'
  add_group 'integration',     'integration'
  add_group 'languages',       'languages'
  add_group 'lib'             do |src_file|
    src_file.filename.include?('lib') &&
    !src_file.filename.include?('app/lib') &&
    !src_file.filename.include?('test/lib')
  end
end

cov_root = File.expand_path('..', File.dirname(__FILE__))
SimpleCov.root cov_root
