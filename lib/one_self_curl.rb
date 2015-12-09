require 'json'

# 1self.co is a startup offering the storage of visualization
# of personal data. It does the cool spinning globe visualization
# on the home page.

class OneSelfCurl

  def initialize(dojo)
    @dojo = dojo
  end

  def parent
    @dojo
  end

  def created(hash)

    data = {
      'objectTags' => ['cyber-dojo'],
      'actionTags' => ['create'],
      'dateTime' => server_time(hash[:now]),
      'location' => {
        'lat'  => hash[:latitude],
        'long' => hash[:longtitude]
      },
      'properties' => {
        'dojo-id' => hash[:kata_id],
        'exercise-name' => hash[:exercise_name],
        'language-name' => hash[:language_name],
        'test-name'     => hash[:test_name]
      }
    }

    args = [
      '--silent',
      '--header content-type:application/json',
      "--header authorization:#{write_token}",
      '-X POST',
      "-d '#{data.to_json}'",
      "#{streams_url}/#{stream_id}/events"
    ].join(space = ' ')

    shell.daemon_exec("curl #{args}")
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def started(avatar)
    # TODO: from one_self.rb.dead
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def tested(avatar, hash)
    # TODO: from one_self.rb.dead
  end

  private

  include ExternalParentChainer

  def server_time(now)
    s = Time.mktime(*now).utc.iso8601.to_s
    # eg 2015-06-25T09:11:15Z
    # the offset to local time is now known (yet)
    # this is represented by removing the Z and adding -00:00
    s[0..-2] + '-00:00'
  end

  def write_token
    'ddbc8384eaf4b6f0e70d66b606ccbf7ad4bb22bfe113'
  end

  def streams_url
    'https://api.1self.co/v1/streams'
  end

  def stream_id
    'GSYZNQSYANLMWEEH'
  end

end
