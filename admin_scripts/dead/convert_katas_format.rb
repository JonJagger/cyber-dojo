#!/usr/bin/env ruby

# One-time data-conversion script. No longer used.
#
# Script to convert katas in old .rb format into new
# katas (with same id) in new .json format.
# After running this
# o) katas dir will contain only .json katas
# o) katas_rb will contain copies of converted .rb katas
# o) katas_rb_bad will contain katas that could not be converted
# The script works by replaying every [test] event from
# the .rb kata into a new .json kata. It takes a long time
# to run.
#
# Originally cyber-dojo saved state on the hard disk
# in .rb files which were read back in and eval'd.
# Later I switched to using .json files but kept
# support for katas in the old .rb format
# so they could be reviewed or resumed.
# This script converts all the old katas in .rb
# format to .json format. After converting the support for
# .rb format was dropped from the models.
# So if you want to run this script you will need support for
# the old .rb format. For that you will need to checkout
# an old commit (before .rb format support was removed)
# The commit id you need is f1e67d2f75a92c32a67d9fa1758173cf4f0f1c97
# Then run this script. It probably won't work!
# Then go back to HEAD

def my_dir
  File.dirname(__FILE__)
end

require my_dir + '/lib_domain'

#- - - - - - - - - - - - - - - - - - - - - - - -

def root_dir
  File.expand_path('..', my_dir)
end

#- - - - - - - - - - - - - - - - - - - - - - - -

def make_time(now)
  [now.year, now.month, now.day, now.hour, now.min, now.sec]
end

#- - - - - - - - - - - - - - - - - - - - - - - -

def calc_delta(was,now)
  result = {
    :unchanged => [ ],
    :changed   => [ ],
    :deleted   => [ ]
  }

  was.each do |filename,content|
    if now[filename] == content
      result[:unchanged] << filename
    elsif !now[filename].nil?
      result[:changed] << filename
    else
      result[:deleted] << filename
    end
    now.delete(filename)
  end

  result[:new] = now.keys
  result
end

#- - - - - - - - - - - - - - - - - - - - - - - -

def clean(s)
  # force an encoding change - if encoding is already utf-8
  # then encoding to utf-8 is a no-op and invalid byte
  # sequences are not detected.
  s = s.encode('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
  s = s.encode('UTF-8', 'UTF-16')
end

#- - - - - - - - - - - - - - - - - - - - - - - -

def replay_rb_as_json(dojo,sid,dot_count)
  s = dojo.katas[sid]
  outer = sid[0..1]
  inner = sid[2..-1]
  raw = s.dir.read('manifest.rb')
  manifest = eval(clean(raw))

  tid = outer + '1'*8
  t = dojo.katas.create_kata(s.language, s.exercise, tid, make_time(s.created))
  t.dir.write('manifest.json', JSON.unparse(manifest))

  s.avatars.each do |avatar|
    tavatar = t.start_avatar([avatar.name])
    prev_visible_files = avatar.visible_files(0)
    max_tag = `cd #{avatar.path};git shortlog`.lines.entries[-2].strip.to_i

    puts "\n(#{dot_count})  #{sid}:#{avatar.name}:#{max_tag}"

     (1..max_tag).each do |tag|
      lights = avatar.traffic_lights(tag)
      last = lights.last
      now = last['time']
      tavatar.save_traffic_light(last,now)
      curr_visible_files = avatar.visible_files(tag)
      delta = calc_delta(prev_visible_files.clone, curr_visible_files.clone)
      tavatar.save(delta, curr_visible_files)
      tavatar.save_manifest(curr_visible_files)
      tavatar.commit(tag)
      prev_visible_files = curr_visible_files
    end
  end

  # mv katas/0A/998360EA to katas_rb/0A/998360EA
  mkdir_cmd = "mkdir -p #{root_dir}/katas_rb/#{outer}"
  `#{mkdir_cmd}`
  mv_cmd = "mv #{root_dir}/katas/#{outer}/#{inner} #{root_dir}/katas_rb/#{outer}/#{inner}"
  `#{mv_cmd}`

  # rename dir 0A/11111111 to 0A/998360EA
  rename_cmd = "mv #{root_dir}/katas/#{outer}/#{'1'*8} #{root_dir}/katas/#{outer}/#{inner}"
  `#{rename_cmd}`

end

#- - - - - - - - - - - - - - - - - - - - - - - - -

def tidy_up(kata,error)
  puts "\n#{error.class} from kata #{kata.id}"
  puts error.message
  outer = kata.id.to_s[0..1]
  inner = kata.id.to_s[2..-1]
  mkdir_cmd = "mkdir -p #{root_dir}/katas_rb_bad/#{outer}"
  `#{mkdir_cmd}`
  mv_cmd = "mv #{root_dir}/katas/#{outer}/#{inner} #{root_dir}/katas_rb_bad/#{outer}/#{inner}"
  `#{mv_cmd}`
  rm_cmd = "rm -rf #{root_dir}/katas/#{outer}/11111111"
  `#{rm_cmd}`
end

#- - - - - - - - - - - - - - - - - - - - - - - - -

puts
dot_count = 0
dojo = create_dojo
dojo.katas.each do |kata|
  if kata.format === 'rb'
    begin
      replay_rb_as_json(dojo,kata.id.to_s,dot_count)
    rescue SyntaxError,
           Encoding::InvalidByteSequenceError,
           ArgumentError,
           NoMethodError => error
      tidy_up(kata,error)
    end
  end
  dot_count += 1
end
puts
puts
