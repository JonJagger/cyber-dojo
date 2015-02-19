
filename = ARGV[0]
filter = ARGV[1]
flat = filter.sub('/','')

html = IO.popen("cat #{filename}").read

pattern = /<div class=\"file_list_container\" id=\"#{flat}\">
\s*<h2>\s*<span class=\"group_name\">#{filter}<\/span>
\s*\(<span class=\"covered_percent\"><span class=\"\w+\">([\d\.]*)\%/m

r = html.match(pattern)

puts "Coverage = #{r[1]}%"
