
index = eval IO.popen('cat dojos/index.rb').read
names = index.map{|e| e[:name]}
p names

