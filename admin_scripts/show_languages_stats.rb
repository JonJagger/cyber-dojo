
require File.expand_path(File.dirname(__FILE__)) + '/domain_lib'

def number(value,width)
  spaces = ' ' * (width - value.to_s.length)
  "#{spaces}#{value.to_s}"
end

disk = OsDisk.new
git = Git.new
runner = NullRunner.new
paas = LinuxPaas.new(disk, git, runner)
format = 'json'
dojo = paas.create_dojo(CYBERDOJO_HOME_DIR, format)

languages_names = dojo.languages.collect {|language| language.name}

print "\n"
renamed,rest,totals = { },{ },{ }
count = 0
dojo.katas.each do |kata|
  begin
    if !languages_names.include? kata.original_language.name
      renamed[kata.original_language.name] ||= [ ]
      renamed[kata.original_language.name] << kata.id
    else
      rest[kata.language.name] ||= [ ]
      rest[kata.language.name] << kata.id
    end
    totals[kata.language.name] ||= 0
    totals[kata.language.name] += 1
  rescue SyntaxError => error
    puts "SyntaxError from kata #{kata.id}"
    puts error.message
  rescue Encoding::InvalidByteSequenceError => error
    puts "Encoding::InvalidByteSequenceError from kata #{kata.id}"
    puts error.message
  end
  count += 1
  dots = '.' * (count % 32)
  spaces = ' ' * (32 - count%32)
  print "\r " + dots + spaces + number(count,4)
end
print "\n"
print "\n"

print "Renamed\n"
count = 0
renamed.keys.sort.each do |name|
  dots = '.' * (32 - name.length)
  print " #{name}#{dots}"
  n = renamed[name].length
  count += n
  print number(n,5)
  print "  #{renamed[name][0]}"
  if name == dojo.languages[name].new_name
    print " --> MISSING new_name "
  else
    print " --> " + dojo.languages[name].new_name
  end
  print "\n"
end
print ' ' * (33)
print number(count,5)
print "\n"
print "\n"

print "Rest\n"
count = 0
rest.keys.sort.each do |name|
  dots = '.' * (32 - name.length)
  print " #{name}#{dots}"
  n = rest[name].length
  count += n
  print number(n,5)
  print "  #{rest[name][0]}"
  print " --> MISSING new_name " if name != dojo.languages[name].new_name
  print "\n"
end
print ' ' * (33)
print number(count,5)
print "\n"
print "\n"

print "Totals\n"
totals.sort_by{|k,v| v}.reverse.each do |name,count|
  dots = '.' * (32 - name.length)
  print " #{name}#{dots}"
  print number(count,5)
  print "\n"
end
print "\n"
print "\n"
