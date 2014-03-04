
module ExposedLinux

  class Paas

    def create_dojo(root_path, format)
      Dojo.new(self,root_path,format)
    end

    def languages_each(dojo)
      pathed = dojo.root_path + '/languages/'
      Dir.entries(pathed).select do |name|
        yield name if is_dir?(File.join(pathed,name))
      end
    end

    def exercises_each(dojo)
      pathed = dojo.root_path + '/exercises/'
      Dir.entries(pathed).each do |name|
        yield name if is_dir?(File.join(pathed,name))
      end
    end

    def make_kata(language,name)
      #here we know
      #language.class == ExposedLinux::Language
      #exercise.class == ExposedLinux::Exercise
      #language.dojo == exercise.dojo
      #do everything needed to create new kata with id==uuid
      id = 'ABCDE12345'
      Kata.new(self,id)
    end

    def katas_each(dojo)
      pathed = dojo.root_path + '../../katas/'
      Dir.entries(pathed).each do |outer_dir|
        outer_path = File.join(pathed,outer_dir)
        if is_dir?(outer_path)
          Dir.entries(outer_path).each do |inner_dir|
            inner_path = File.join(outer_path,inner_dir)
            yield outer_dir+inner_dir if is_dir?(inner_path)
          end
        end
      end
    end

    def start_avatar
      #do what needs to be done
      Avatar.new(self,'lion')
    end

    def avatars_each(kata)
      #
    end

    def avatar_test(delta,visible_files)
      #...
    end

    def avatar_visible_files(tag)
      #...
    end

    def avatar_traffic_lights(tag)
      #...
    end

  private

    def is_dir?(name)
      File.directory?(name) && !name.end_with?('.') && !name.end_with?('..')
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
