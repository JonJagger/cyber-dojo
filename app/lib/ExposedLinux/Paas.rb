require 'Dojo'

module ExposedLinux

  class Paas

    def create_dojo(root_path, format)
      Dojo.new(self,root_path,format)
    end

    def languages_each(dojo)
      ["Java","Ruby"].each do |name|
        yield name
      end
    end

    def exercises_each(dojo)
      ["Fizz Buzz","Roman Numerals"].each do |name|
        yield name
      end
    end

    def make_kata(language,name)
      #here we know
      #language.class == ExposedLinux::Language
      #exercise.class == ExposedLinux::Exercise
    end

  end

end

# idea is that this will hold methods that forward to external
# services namely: disk, git, shell.
# And I will create another implementation IsolatedDockerPaas
# Design notes
# o) each model object; kata, avatar, sandbox, should know
#    its identity but should not catenate id's together - that
#    should be done by the Paas.
#
# o) each model will not expose a dir method. Instead I will
#    access the dirs off the paas object.
#
# o) methods that are different across paas' will not be
#    run inside the model objects but will forward the call
#    back to their paas. Viz
#       - dojo.create_kata(language,exercise)
#       - dojo.katas.each
#       - kata.create_avatar
#       - kata.avatars.each
#       - output = avatar.test(delta, visible_files)
#       -     (collapse everything down for that?)
#       - avatar.visible_files(tag)
#       - avatar.traffic_lights(tag)
#
#       - how will IsolatedDockerPaas know a languages'
#         initial visible_files? use same manifest format?
#         seems reasonable. Could even repeat the languages subfolder
#         pattern. No reason a Docker container could not support
#         several variations of language-unit-test.
#       - the docker container could have ruby code installed to
#         initialize an avatar from a language. All internally.
#         would save many docker run calls.
#
# o) tests will be passed a paas object which they will use
#    idea is to repeat same test for several paas objects
#    eg one that spies completely
#    eg one that uses ExposedLinuxPaas
#    eg one that uses IsolatedDockerPaas
