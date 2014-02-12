
require 'sqlite3'
require './script_lib'

def avatars
  %w(
      alligator buffalo cheetah deer
      elephant frog gorilla hippo
      koala lion moose panda
      raccoon snake wolf zebra
    )
end

def dojo_row(dir,id)
  manifest = eval `cat #{dir}/manifest.rb`  
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
  [id,language,exercise,animals,reds,ambers,greens,votes]  
end

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Open a SQLite 3 database file
cyberDojo = SQLite3::Database.new 'cyberDojo.db'

# TEMP (dev iteration)...
cyberDojo.execute 'DELETE FROM dojos'

count = 0
index("." + "/katas") do |dir,id|
  cyberDojo.execute 'insert into dojos values (?,?,?,?,?,?,?,?)', dojo_row(dir,id)
  count += 1
  print "\r#{count} inserted"
end

puts ""

# Find some records
count = 0
cyberDojo.execute 'SELECT * FROM dojos' do |row|
  count += 1
end
puts "#{count} retrieved"
