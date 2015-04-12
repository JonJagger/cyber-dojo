
# these dependencies have to be loaded in the correct order
# as some of them depend on loading previous ones

require 'json'
require_relative './lib/all'
require_relative './app/helpers/all'
require_relative './app/lib/all'
require_relative './app/models/all'

#Line 16 fails with
# uninitialized constant ApplicationController 
#because SetupController < ApplicationController
#I've changed something somewhere which means ApplicationController
#is no longer being loaded (or would be loaded too late)
#require_relative './app/controllers/setup_controller.rb'
