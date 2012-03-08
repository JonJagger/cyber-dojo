
def name_or_diff_from(manifest)
  manifest[:name] || "#{manifest[:diff_id]}-#{manifest[:diff_avatar]}-#{manifest[:diff_tag]}"
end

find = ARGV[0]
index = eval IO.popen('cat katas/index.rb').read
ids = index.map{|e| e[:id]}
ids.each do |id|
  inner_dir = id[0..1]   
  outer_dir = id[2..9]
  kata_dir = "katas/#{inner_dir}/#{outer_dir}"
  manifest = eval IO.popen("cat #{kata_dir}/manifest.rb").read
  if name_or_diff_from(manifest) == find
    print find + ' --> /katas/' + inner_dir + '/' + outer_dir +
      "\t" + manifest[:language] +
      ", " + manifest[:exercise] + "\r\n"
  end
end


