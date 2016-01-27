
# these dependencies have to be loaded in the correct order
# as some of them depend on loading previous ones
# app/controllers/application_controller.rb load()s this file.

require 'json'
require_relative './lib/all'
require_relative './app/helpers/all'
require_relative './app/lib/all'
require_relative './app/models/all'
