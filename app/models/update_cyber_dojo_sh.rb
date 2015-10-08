
module UpdateCyberDojoSh # mix-in

  module_function

  def update_cyber_dojo_sh(files)
    # The base docker containers were refactored to avoid volume-mounting
    # as part of the docker-swarm re-architect work. The support_files
    # were moved *inside* their docker containers by ADD'ing them to the
    # appropriate Dockerfile. This often required a path-related change to
    # the cyber-dojo.sh file. This is no problem for dojos started after
    # the re-architecture but it is for test/fork/revert in a dojo
    # started *before* the re-architecture.
    #
    # To help in this situation the new master cyber-dojo.sh is appended
    # (in # comments) to the end of the existing cyber-dojo.sh file.
    # There are two reasons for doing it this way rather than the old
    # cyber-dojo.sh file being commented out and the new master pre-pended
    # to it.
    #
    # 1. Suppose the users cyber-dojo.sh has some custom mods and they
    #    tweak it in light of new info (eg new paths).
    #    The next [test] would set these back to comments!
    #
    # 2. It follows the philosophy of cyber-dojo, that the user is in charge.
    #    To quote Martin Richards, of BCPL fame
    #      "The philosophy of BCPL is not one of the tyrant who thinks
    #       he knows best and lays down the law on what is and what is
    #       not allowed; rather BCPL acts more as a servant offering
    #       his services to the best of his ability without complaint,
    #       even when confronted with apparant nonsense."
    #               BCPL the language and its compiler
    #               Martin Richards and Colin Whitby-Strevens
    #               ISBN 0-521-21965-5

    content = files['cyber-dojo.sh'].strip
    needs_update = !content.include?(cyber_dojo_sh) && !content.include?(commented_cyber_dojo_sh)
    if needs_update
      files['cyber-dojo.sh'] =
        content +
        separator +
        cyber_dojo_sh_alert +
        separator +
        commented_cyber_dojo_sh
    end
    needs_update
  end

  def cyber_dojo_sh_alert
    [
      '# <ALERT>',
      '# The lines in this cyber-dojo.sh file (above this alert) differ from the',
      '# lines in the master cyber-dojo.sh file (below this alert). If this file',
      '# is not working please examine the differences. Editing or removing the',
      '# master (below this alert) will re-trigger the alert!',
      '# </ALERT>'
    ].join("\n")
  end

  def update_output(output, cyber_dojo_sh_updated)
    # If the cyber-dojo.sh file has been modified (see above)
    # the output also contains an alert
    cyber_dojo_sh_updated ? output_alert + separator + output : output
  end

  def output_alert
    [
      'ALERT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>',
      'ALERT >>>          possible problem detected           >>>',
      'ALERT >>>   examine cyber-dojo.sh for detailed info    >>>',
      'ALERT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
    ].join("\n")
  end

  def cyber_dojo_sh
    language.visible_files['cyber-dojo.sh'].strip
  end

  def commented_cyber_dojo_sh
    cyber_dojo_sh.split("\n").map { |line| '#' + line }.join("\n")
  end

  def separator
    "\n\n"
  end

end

