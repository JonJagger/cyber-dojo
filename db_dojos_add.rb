
require 'sqlite3'
require 'JSON'
require './script_lib' # for index()

def avatars
  %w(
      alligator buffalo cheetah deer
      elephant frog gorilla hippo
      koala lion moose panda
      raccoon snake wolf zebra
    )
end

# this is using inspected objects.
# better to create another script to convert a dojo to JSON format
# and then run this in JSON format.
# That way it will be ready to run when the JSON conversion is
# done on cyber-dojo.com
# Conversion will need to do
# Kata's
#    manifest.rb  -> manifest.json
# Avatar's
#    manifest.rb  -> visible_files.json
#   increments.rb -> traffic_lights.json
# Don't think I need to do
# Language or Exercise (yet) but will need to do them
# when converting cyber-dojo.com to JSON

def dojo_row(dir,id)
  manifest = eval `cat #{dir}/manifest.rb`  
  created  = JSON.unparse(manifest[:created])
  # manifest also contains [:unit_test_framework]
  language = manifest[:language]
  exercise = manifest[:exercise]
  animals,reds,ambers,greens,votes = 0,0,0,0,0
  avatars.each do |avatar|
    inc_filename = "#{dir}/#{avatar}/increments.rb"
    if File.exists? inc_filename
      animals += 1
      incs = eval `cat #{inc_filename}`
      incs.each do |light|
        colour = light[:colour] || light[:outcome]
        if colour == :red;   reds   += 1; end
        if colour == :amber; ambers += 1; end
        if colour == :green; greens += 1; end
      end
    end
  end    
  [id,created,language,exercise,animals,reds,ambers,greens,votes]  
end

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Open a SQLite 3 database file
cyberDojo = SQLite3::Database.new 'cyberDojo.db'

# TEMP (dev iteration)...
cyberDojo.execute 'DELETE FROM dojos'

count = 0
index("." + "/katas") do |dir,id|
  cyberDojo.execute('INSERT INTO dojos VALUES (?,?,?,?,?,?,?,?,?)', dojo_row(dir,id))
  count += 1
  print "\r#{count} inserted"
end

puts ""

# Find some records
count = 0
cyberDojo.execute('SELECT * FROM dojos') do |row|
  count += 1
end
puts "#{count} retrieved"
