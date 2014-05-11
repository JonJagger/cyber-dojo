
# script to show frequency of katas by first 2 digits of their id.
# for example, suppose the output is
# Frequencies (221/255)
#    1................................................................64
#    2..........................................................................74
#    3...........................................43
#    4.......................23
#    5............12
#    6..2
#    7...3
#
# then this means
#
# 64 2-digit codes have 1 kata
# 74 2-digit codes have 2 katas
# 43 2-digit codes have 3 katas
# 23 2-digit codes have 4 katas
# 12 2-digit codes have 5 katas
#  2 2-digit codes have 6 katas
#  3 2-digit codes have 7 katas
#
# where 2-digit code are, eg, 34 E4 02 F8
# the first two digits of katas ids.

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

print "\n"
totals = { }
count = 0
dojo.katas.each do |kata|
  smid = kata.id.to_s[0..1]
  totals[smid] ||= 0
  totals[smid] += 1
  count += 1
  dots = '.' * (count % 32)
  spaces = ' ' * (32 - count%32)
  print "\r " + dots + spaces + number(count,4)
end
print "\n"
print "\n"

freqs = { }
tally = 0
totals.each do |smid,count|
  freqs[count] ||= 0
  freqs[count] += 1
  tally += 1
end

print "Frequencies (#{tally}/255)\n"
freqs.sort.each do |count,freq|
  print number(count,5)
  dots = '.' * freq
  print dots + freq.to_s
  print "\n"
end
print "\n"
print "\n"
