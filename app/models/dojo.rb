# See comments at end of file
# See cyber-dojo-model.pdf

class Dojo

  def languages; @languages ||= Languages.new(self, env_root); end
  def exercises; @exercises ||= Exercises.new(self, env_root); end
  def katas    ; @katas     ||=     Katas.new(self, env_root); end
  def caches   ; @caches    ||=    Caches.new(self, env_root); end

  def runner  ; @runner   ||= env_object('DockerRunner').new      ; end
  def disk    ; @disk     ||= env_object('HostDisk'    ).new      ; end
  def git     ; @git      ||= env_object('HostGit'     ).new      ; end
  def one_self; @one_self ||= env_object('OneSelfCurl' ).new(disk); end

  private

  def env_root
    var = 'CYBER_DOJO_' + name_of(caller).upcase + '_ROOT'
    default = "/var/www/cyber-dojo/#{name_of(caller)}"
    root = ENV[var] || default
    root + (root.end_with?('/') ? '' : '/')
  end

  def env_object(default)
    var = 'CYBER_DOJO_' + name_of(caller).upcase + '_CLASS'
    Object.const_get(ENV[var] || default)
  end

  def name_of(caller)
    # eg caller[0] == "dojo.rb:7:in `exercises'"
    /`(?<name>[^']*)/ =~ caller[0] && name
  end

end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# External paths/class-names can be set via environment variables.
#
# CYBER_DOJO_LANGUAGES_ROOT
# CYBER_DOJO_EXERCISES_ROOT
# CYBER_DOJO_KATAS_ROOT
# CYBER_DOJO_CACHES_ROOT
#
# CYBER_DOJO_RUNNER_CLASS
# CYBER_DOJO_DISK_CLASS
# CYBER_DOJO_GIT_CLASS
# CYBER_DOJO_ONE_SELF_CLASS
#
# The main reason for this arrangement is testability.
# For example, I can run controller tests by setting the
# environment variables, then run the test which issue
# a GET/POST, let the call work its way through the rails stack,
# eventually reaching Dojo.rb where it creates
# Disk/Runner/Git/OneSelf objects as named in the ENV[]
# I cannot see how to do this using Parameterize-From-Above
# since I know of no way to 'tunnel' the parameters 'through'
# the rails stack.
#
# It also allows me to do polymorphic testing, viz to rerun
# the *same* test under different environments.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
