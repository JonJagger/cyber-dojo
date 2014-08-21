#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/lib_domain'
require 'csv'

# displays data in screen-friendly format if true, csv format if false or blank
arg = (ARGV[0] || "")

def deleted_file(lines)
    lines.all? { |line| line[:type] === :deleted }
end

def new_file(lines)
    lines.all? { |line| line[:type] === :added }
end

dojo = create_dojo

# temporary limiter for TESTING ONLY, remove all lines referencing 'lim' for full functionality
lim = 20
dojo.katas.each do |kata|
    language = kata.language.name

    if language == "Java-1.8_JUnit"
        lim -= 1

        kata.avatars.active.each do |avatar|
            lights = avatar.lights
            num_lights = lights.count
            num_cycles = 1
            kata_line_count = 0
            num_red, num_green, num_amber = 0, 0, 0
            endsOnGreen = false

            transitions = "["
            lights.each_cons(2) do |was,now|
                case was.colour.to_s
                when "red"
                    num_red += 1
                when "green"
                    num_green += 1
                when "amber"
                    num_amber += 1
                end
                transitions += was.colour.to_s

                # locate cycle transitions and add '|' to designate
                if now.colour.to_s == "red" && was.colour.to_s != "red"
                    transitions += "]["
                    num_cycles += 1
                else
                    transitions += ":"
                end

                # determine number of lines changed between lights
                line_count = 0;
                diff = avatar.tags[was.number].diff(now.number)
                diff.each do |filename,lines|
                    non_code_filenames = [ 'output', 'cyber-dojo.sh', 'instructions' ]
                    if !non_code_filenames.include?(filename) && !deleted_file(lines) && !new_file(lines)
                        line_count += lines.count { |line| line[:type] === :added }
                        line_count += lines.count { |line| line[:type] === :deleted }
                    end
                end
                transitions += line_count.to_s + ":"
                kata_line_count += line_count
            end

            # handle last light that was examined by consecutive loop above
            case lights[lights.count-1].colour.to_s
            when "red"
                num_red += 1
            when "green"
                num_green += 1
                endsOnGreen = true
            when "amber"
                num_amber += 1
            end
            transitions += lights[lights.count-1].colour.to_s + "]"
            
            if File.exist?(avatar.path+ 'CodeCoverageReport.csv')
                codeCoverageCSV = CSV.read(avatar.path+ 'CodeCoverageReport.csv')
                branchCoverage =  codeCoverageCSV[2][6]
                statementCoverage =  codeCoverageCSV[2][16]
            end
            cyclomaticComplexity = `./javancss "#{avatar.path + "sandbox/*.java"}"`


            if arg == "true"
                printf("kata id:\t%s\nexercise:\t%s\nlanguage:\t%s\n", kata.id.to_s, kata.exercise.name.to_s, language)
                printf("avatar:\t\t%s [%s in kata]\n", avatar.name, kata.avatars.count.to_s)
                printf("path:\t\t%s\n", avatar.path)
                printf("num of lights:\t%s  =>  red:%s, green:%s, amber:%s\n", lights.count.to_s, num_red.to_s, num_green.to_s, num_amber.to_s) 
                printf("num of cycles:\t%s\t\ttotal lines changed:%s\n", num_cycles.to_s, kata_line_count.to_s)
                printf("ends of green:\t%s\n", endsOnGreen)
                printf("log:\t\t%s\n\n", transitions)
            else
                printf("%s,%s,%s,%s,%s,", kata.id.to_s, language, kata.exercise.name.to_s, kata.avatars.count.to_s, avatar.name)
                printf("%s,%s,%s,%s,%s,",avatar.path, lights.count.to_s, num_red.to_s, num_green.to_s, num_amber.to_s)
                printf("%s,%s,%s", branchCoverage,statementCoverage,cyclomaticComplexity)
                printf("%s,%s,%s\n", num_cycles.to_s, endsOnGreen, transitions)
            end
        end

    end

    break if lim <= 0
end
