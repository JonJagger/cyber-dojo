
# Script to show frequency of katas by first 2 digits of their id.
# If there is a bias in the generation of random kata ids this
# may help show it. For example, suppose the output is
#
# Frequencies (221/255)
#
#    1................................................................64
#    2..........................................................................74
#    3...........................................43
#    4.......................23
#    5............12
#    6..2
#    7...3
#
# What are we counting?
# The number of katas underneath the 2-digit katas/sub-folder
# eg katas/34 katas/E4 katas/02 katas/F8 etc
#
# 64 sub-folders have 1 kata
# 74 sub-folders have 2 katas
# 43 sub-folders have 3 katas
# 23 sub-folders have 4 katas
# 12 sub-folders have 5 katas
#  2 sub-folders have 6 katas
#  3 sub-folders have 7 katas
#

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

print "Frequencies (#{tally}/256)\n"
print "\n"
freqs.sort.each do |count,freq|
  print number(count,5) + ' ' + ('.' * freq) + freq.to_s + "\n"
end
print "\n"
print "\n"
