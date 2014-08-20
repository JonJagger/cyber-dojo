#!/usr/bin/env ruby

# A ruby script to display the count of
#   dojos per day
#   dojos per language
#   dojos per exercise
# to see the ids of all counted dojos (in their catagories)
# append true to the command line

require File.dirname(__FILE__) + '/lib_domain'

show_ids = (ARGV[0] || "false")

def deleted_file(lines)
    lines.all? { |line| line[:type] === :deleted }
end

def new_file(lines)
    lines.all? { |line| line[:type] === :added }
end


$dot_count = 0
dojo = create_dojo

$stop_at = 1

puts
days,weekdays,languages,exercises = { },{ },{ },{ }
dot_count = 0
exceptions = [ ]
cyclomaticComplexity = ""
dojo.katas.each do |kata|
    begin
        
        language = kata.language.name
        if language == "Java-1.8_JUnit"

            kata.avatars.active.each do |avatar|
                $dot_count += 1
                puts avatar.path
                #                copyCommand =  "cp "+avatar.path + "sandbox/*.java ./calcCodeCovg/tempDir"
                `rm ./calcCodeCovg/src/*`
                `rm -r ./calcCodeCovg/isrc/*`
                `rm -r ./*.clf`

                `cp #{avatar.path}sandbox/*.java ./calcCodeCovg/src`
                allFiles =  Dir.entries("./calcCodeCovg/src/")
                currTestClass = ""
                allFiles.each do |currFile|
                    puts currFile
                    initialLoc = currFile.to_s =~ /test/i
                    #puts initialLoc
                    unless initialLoc.nil?
                        fileNameParts = currFile.split('.')
                        currTestClass = fileNameParts.first
                        puts currTestClass
                    end
                end
                `java -jar ./calcCodeCovg/libs/codecover-batch.jar instrument --root-directory ./calcCodeCovg/src --destination ./calcCodeCovg/isrc --container ./calcCodeCovg/src/con.xml --language java --charset UTF-8`
                
                `javac -cp ./calcCodeCovg/libs/*:./calcCodeCovg/isrc ./calcCodeCovg/isrc/*.java`
                
                puts `java -cp ./calcCodeCovg/libs/*:./calcCodeCovg/isrc org.junit.runner.JUnitCore #{currTestClass}`
               
            
            end
        end
        rescue Exception => error
        exceptions << error.message
    end
    #dot_count += 1
     break if $dot_count >= $stop_at
    #print "\r " + dots(dot_count)
end
puts
puts


