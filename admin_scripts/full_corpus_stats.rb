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



dojo = create_dojo

puts
days,weekdays,languages,exercises = { },{ },{ },{ }
dot_count = 0
exceptions = [ ]
dojo.katas.each do |kata|
    begin
        language = kata.language.name
        if language == "Java-1.8_JUnit"

            kata.avatars.active.each do |avatar|
                #print kata.id.to_s + ","
                #print kata.exercise.name.to_s + ","
                #print kata.avatars.count.to_s + ","

#print avatar.name + ","
#print avatar.path + ","
                lights = avatar.lights
                #               print lights.count.to_s+ ","
                kata_line_count = 0;
                num_red = 0;
                num_green = 0;
                num_amber = 0;
                transitionsString = ""
                lights.each_cons(2) do |was,now|
                    if was.colour.to_s === "red"
                        num_red += 1
                    end
                    if was.colour.to_s === "green"
                        num_green += 1
                    end
                    if was.colour.to_s === "amber"
                        num_amber += 1
                    end
                    transitionsString +=  was.colour.to_s + ":"
                    line_count = 0;
                    diff = avatar.tags[was.number].diff(now.number)
                    diff.each do |filename,lines|
                        non_code_filenames = [ 'output', 'cyber-dojo.sh', 'instructions' ]
                        if !non_code_filenames.include?(filename) &&
                          !deleted_file(lines) &&
                          !new_file(lines)
                            line_count += lines.count { |line| line[:type] === :added }
                            line_count += lines.count { |line| line[:type] === :deleted }
                        end
                    end
                    transitionsString+=  line_count.to_s + ":"
                    kata_line_count += line_count
                end
                transitionsString += lights[lights.count-1].colour.to_s
                endsOnGreen = false
                if lights[lights.count-1].colour.to_s === "red"
                    num_red += 1
                end
                if lights[lights.count-1].colour.to_s === "green"
                    num_green += 1
                    endsOnGreen = true
                end
                if lights[lights.count-1].colour.to_s === "amber"
                    num_amber += 1
                end
                
                #print ","
                #print kata_line_count.to_s
                #print ","
                #puts
                printf("\n%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s",kata.id.to_s,kata.exercise.name.to_s,kata.avatars.count.to_s,avatar.name,avatar.path,lights.count.to_s,transitionsString,kata_line_count.to_s,num_red,num_green,endsOnGreen,num_amber)
                
                #printf("\nKata id:%s\nKata name:%s\nNumber of Avatars in Kata:%s\nAvatar Name:%s\nAvatar Path:%s\nTotal Number of Lights:%s\nTotal Red Lights:%s\nTotal Green Lights:%s\nTotal Amber Lights%s\ntransitionString:%s\nTotal Lines changed in kata:%s",kata.id.to_s,kata.exercise.name.to_s,kata.avatars.count.to_s,avatar.name,avatar.path,lights.count.to_s,num_red,num_green,num_amber,transitionsString,kata_line_count.to_s)
                #puts
            end
        end
        rescue Exception => error
        exceptions << error.message
    end
    #dot_count += 1
    
    #print "\r " + dots(dot_count)
end
puts
puts


