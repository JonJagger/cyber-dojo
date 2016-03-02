require 'simplecov'

SimpleCov.start do
  filters.clear

  add_group 'app/controllers', 'app/controllers'
  add_group 'app/models',      'app/models'
  add_group 'app/helpers',     'app/helpers'
  add_group 'app/lib',         'app/lib'

  #add_group 'integration',     'integration'
  #add_group 'languages',       'languages'
  add_group 'lib'             do |src|
    src.filename.include?('cyber-dojo/lib')
  end
end

cov_root = File.expand_path('..', File.dirname(__FILE__))
SimpleCov.root cov_root
