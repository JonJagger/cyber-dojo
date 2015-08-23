#!/usr/bin/env ruby

def conversion
  [
    [ "cyberdojo/bash",    "cyberdojofoundation/bash" ],
    [ "cyberdojo/gpp-4.9", "cyberdojofoundation/gpp-4.9" ],
  ]
end

def installed_images
  output = `docker images 2>&1`
  lines = output.split("\n").select{|line| line.start_with?('cyberdojo')}
  lines.collect{|line| line.split[0]}.sort
end

def update_images
  images = installed_images
  images.each do |image|
    update_to = image
    print image
    index = conversion.find_index{|p| p[0]===image}
    if index != nil
      update_to = conversion[index][1]
      print " -> #{update_to}"
    end
    print "\n"
  end
end

def remove_old_images
  images = installed_images
  images.each do |image|
    index = conversion.find_index{|p| p[0]===image}
    if index != nil
      print "Removing " + image + "\n"
    end
  end
end

def console_break
  puts "--------------------------------------------------------------------------------"
end

if ($0 == __FILE__)
  console_break
  puts "Pulling latest images"
  console_break
  update_images
end

if (ARGV[0] === "clean")
  console_break
  puts "Removing old images"
  console_break
  remove_old_images
end
