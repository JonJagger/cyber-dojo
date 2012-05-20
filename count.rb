# ruby count.rb
# [2012, 5,17, "Tue"] 4
# [2012, 5,18, "Wed"] 6

def recent(array, max_length)
  len = [array.length, max_length].min
  array[-len,len]
end

stats = { }
index = eval IO.popen('cat katas/index.rb').read
show = (ARGV[0] || index.length).to_i
recent(index,show).each do |entry|
  begin
    created = Time.mktime(*entry[:created])
    ymd = [created.year, created.month, created.day, created.strftime('%a')]
    stats[ymd] ||= 0
    stats[ymd] += 1
  rescue
    print "---->Exception raised for ID:#{entry[:id]}, browser:#{entry[:browser]}\n"
  end
end

stats.each do |ymdw,n|
  print ymdw.inspect + "\t" + n.to_s + "\n"
end

