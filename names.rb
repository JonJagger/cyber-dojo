# ruby names.rb
# >June 19 15:17 CA/CFEFD714 php-caret [4,9,13] -> 26 
# >June 29 19:05 F6/89352E7A dojo-name [0,1,3] -> 4
# Columns are: Date, Time, Folder, Name, Language, Exercise
#             [Increments per avatar], Total Number of Increments, Browser

def recent(array, max_length)
  len = [array.length, max_length].min
  array[-len,len]
end

def avatars
  %w(
      alligator buffalo cheetah deer
      elephant frog gorilla hippo
      koala lion moose panda
      raccoon snake wolf zebra
    )
end

def name_or_diff_from(manifest)
  manifest[:name] || "#{manifest[:diff_id]}-#{manifest[:diff_avatar]}-#{manifest[:diff_tag]}"
end

def show_one(id)
  inner_dir = id[0..1]   
  outer_dir = id[2..9]
  kata_dir = "katas/#{inner_dir}/#{outer_dir}"
  manifest = eval IO.popen("cat #{kata_dir}/manifest.rb").read
  created = Time.mktime(*manifest[:created])

  inc_lengths = [ ]
  avatars.each do |avatar|
    if File.directory? kata_dir + '/' + avatar
      incs = eval IO.popen("cat #{kata_dir}/#{avatar}/increments.rb").read
      inc_lengths << incs.length
    end
  end
  
  print created.strftime('%b %d %H:%M') + 
    ' ' + inner_dir + '/' + outer_dir + 
    ' ' + '{' + name_or_diff_from(manifest) + '}, ' +
    ' ' + manifest[:language] + ', ' +
    ' ' + manifest[:exercise] + ', ' +
    ' ' + '[' + inc_lengths.sort.join(',') + '] -> ' + inc_lengths.reduce(:+).to_s +
    ' ' + (manifest[:browser] || "") +
    "\n"
end

index = eval IO.popen('cat katas/index.rb').read
show = (ARGV[0] || "32").to_i
recent(index,show).each do |entry|
  id = entry[:id]
  print "\n"
  begin
    show_one(id)
  rescue
    print "---->Exception raised for ID:#{id}, browser:#{entry[:browser]}\n"
  end
end
print "\n"
