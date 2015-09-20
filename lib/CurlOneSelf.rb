require 'json'
require_relative 'BackgroundProcess'

class CurlOneSelf

  def initialize(disk, process = BackgroundProcess.new)
    @process = process
  end

  def created(hash)
    data = {
      'objectTags' => [ 'cyber-dojo' ],
      'actionTags' => [ 'create' ],
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

    curl = 'curl' +
      ' --silent' +
      ' --header content-type:application/json' +
      " --header authorization:#{write_token}" +
      ' -X POST' +
      " -d '#{data.to_json}'" +
      " #{streams_url}/#{stream_id}/events"

    @process.start(curl)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def started(avatar)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def tested(avatar,hash)
  end

private

    def server_time(now)
      s = Time.mktime(*now).utc.iso8601.to_s
      # eg 2015-06-25T09:11:15Z
      # the offset to local time is now known (yet)
      # this is represented by removing the Z and adding -00:00
      s[0..-2] + "-00:00"
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
