#!/usr/bin/env ruby

# Script (IN PROGRESS) to convert katas in old .rb format into new
# katas (with new id) in new .json format

require File.dirname(__FILE__) + '/lib_domain'

def convert(tdir, sdir, prefix)
  manifest = eval(sdir.read(prefix + '.rb'))
  tdir.write(prefix + '.json', JSON.unparse(manifest))
end

def make_time(now)
  [now.year, now.month, now.day, now.hour, now.min, now.sec]
end

def calc_delta(was,now)
  result = {
    :unchanged => [ ],
    :changed   => [ ],
    :deleted   => [ ]
  }

  was.each do |filename,content|
    if now[filename] == content
      result[:unchanged] << filename
    elsif now[filename] != nil
      result[:changed] << filename
    else
      result[:deleted] << filename
    end
    now.delete(filename)
  end

  result[:new] = now.keys
  result
end

def replay(dojo,sid)
  s = dojo.katas[sid]

  tid = sid.reverse
  t = dojo.katas.create_kata(s.language, s.exercise, tid, make_time(s.created))

  convert(t.dir, s.dir, 'manifest')

  s.avatars.each do |avatar|
    tavatar = t.start_avatar([avatar.name])

    prev_visible_files = avatar.visible_files(0)

    max_tag = `cd #{avatar.path};git shortlog`.lines.entries[-2].strip.to_i
    puts "#{avatar.name}:#{max_tag}"
    (1..max_tag).each do |tag|
      lights = avatar.traffic_lights(tag)
      last = lights.last
      now = last['time']
      tavatar.save_traffic_light(last,now)

      curr_visible_files = avatar.visible_files(tag)
      #puts "#{tag}:filenames #{curr_visible_files.keys.sort}"

      delta = calc_delta(prev_visible_files.clone, curr_visible_files.clone)

      #puts "#{tag}:unchanged #{delta[:unchanged].sort}"
      #puts "#{tag}:  changed #{delta[:changed].sort}"
      #puts "#{tag}:  deleted #{delta[:deleted].sort}"
      #puts "#{tag}:      new #{delta[:new].sort}"

      tavatar.save(delta, curr_visible_files)
      tavatar.save_visible_files(curr_visible_files)
      prev_visible_files = curr_visible_files

      tavatar.commit(tag)
    end

  end
end

dojo = create_dojo
replay(dojo,'0A998360EA')

#- - - - - - - - - - - - - - - - - - - - - - - - -

puts
dot_count = 0
dojo.katas.each do |kata|
  # if kata.format === 'rb'
  #   do conversion, eg
  #     if  source id = 0A998360EA
  #     use target id = 0A11111111
  #     delete the old kata
  #     rename dir 0A/11111111 to 0A/998360EA
  # end
  dot_count += 1
  print "\r " + dots(dot_count)
end
puts
puts
