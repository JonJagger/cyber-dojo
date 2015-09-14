#!/usr/bin/env ruby

# script to generate test ids for use in TestWithId.rb

def id
  `uuidgen`.strip.delete('-')[0...6].upcase
end

10.times { 
  print "id['#{id}'].\n" 
}
