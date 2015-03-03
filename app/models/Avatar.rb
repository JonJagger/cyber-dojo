# comments at end of file

class Avatar

  def initialize(kata,name)
    raise 'Invalid Avatar(name)' if !Avatars.valid?(name)
    @kata,@name = kata,name
  end

  attr_reader :kata, :name

  def exists?
    dir.exists?
  end

  def start
    dir.make
    setup_git_repo
    write_manifest(kata.visible_files)
    git(:add, manifest_filename)
    write_increments([ ])
    git(:add, increments_filename)     
    sandbox.start
    commit(0)    
    event_1self_avatar_start
  end
  
  def path
    kata.path + name + '/'
  end

  def active?
    exists? && lights.count > 0
  end

  def tags
    Tags.new(self)
  end

  def lights
    increments.map { |inc| Light.new(self,inc) }
  end

  def visible_files
    JSON.parse(read(manifest_filename))
  end

  def test(delta, visible_files, now = time_now, time_limit = 15)    
    new_files,filenames_to_delete = sandbox.run_tests(delta,visible_files,time_limit)
    colour = kata.language.colour(visible_files['output'])
    rags = increments
    rag = {
      'colour' => colour,
      'time'   => now,
      'number' => rags.length + 1
    }
    rags << rag
    write_increments(rags)
    write_manifest(visible_files)
    tag = rags.length
    commit(tag)
    event_1self_test(tag,colour)
    [rags,new_files,filenames_to_delete]
  end

  def diff(n,m)
    command = "--ignore-space-at-eol --find-copies-harder #{n} #{m} sandbox"
    diff_lines = git(:diff, command)
    visible_files = tags[m].visible_files
    git_diff(diff_lines, visible_files)
  end

  def sandbox
    Sandbox.new(self)
  end

private

  include ExternalDiskDir
  include ExternalGit
  include GitDiff
  include TimeNow

  def commit(tag)
    git(:commit, "-a -m '#{tag}' --quiet")
    git(:gc, '--auto --quiet')
    git(:tag, "-m '#{tag}' #{tag} HEAD")
  end

  def write_manifest(visible_files)
    write(manifest_filename, visible_files)
  end

  def write_increments(increments)
    write(increments_filename, increments)    
  end
  
  def write(filename,content)
    dir.write(filename,content)
  end
  
  def read(filename)
    dir.read(filename)
  end
  
  def increments
    @increments ||= JSON.parse(read(increments_filename))
  end

  def manifest_filename
    'manifest.json'
  end
    
  def increments_filename
    'increments.json'
  end

  def setup_git_repo
    git(:init, '--quiet')    
    git(:config, user_name)
    git(:config, user_email)
  end

  def user_name
    "user.name #{quoted(name + '_' + kata.id)}"
  end

  def user_email 
    "user.email #{quoted(name)}@cyber-dojo.org"
  end

  def quoted(s)
    '"' + s + '"'
  end

  # - - - - - - - - - - - - - - - -
  
  def event_1self_avatar_start
    url = URI.parse(one_self_base_url)
    http = Net::HTTP.new(url.host)
    header = { 'Content-Type' =>'application/json',
               'Authorization' => "#{app_key}:#{app_secret}" }    
    request = Net::HTTP::Post.new(url.path, header)
    body =  JSON.parse(http.request(request).body)
    one_self = {
      :stream_id => body['streamid'],
      :read_token => body['readToken'],
      :write_token => body['writeToken']
    }
    write(one_self_manifest_filename, one_self)            
  end
  
  # - - - - - - - - - - - - - - - -
  
  def event_1self_test(tag,colour)  
    added_line_count,deleted_line_count = line_counts(diff(tag-1,tag))    
    stream_id = one_self['stream_id']
    data = {
      'objectTags' => [ 'cyber-dojo' ],
      'actionTags' => [ 'test-run' ],
      'properties' => {
        'color' => colour,
        'diffCount' => (added_line_count+deleted_line_count),
        'dojoId' => kata.id,
        'avatar' => name
      }
    }
    url = URI.parse("#{one_self_base_url}/#{stream_id}/events")
    http = Net::HTTP.new(url.host)
    header = { 'Content-Type' =>'application/json',
               'Authorization' => "#{one_self['write_token']}" }    
    request = Net::HTTP::Post.new(url.path, header)
    request.body = data.to_json
    response = http.request(request)
  end
  
  def one_self
    @one_self ||= JSON.parse(read(one_self_manifest_filename))
  end

  # copy-pasted from app/helpers/tip_helper.rb
  def line_counts(diffed_files)
    added_count,deleted_count = 0,0
    diffed_files.each do |filename,diff|
      if filename != 'output'
        added_count   += diff.count { |line| line[:type] == :added   }
        deleted_count += diff.count { |line| line[:type] == :deleted }
      end
    end
    [added_count,deleted_count]
  end

  def one_self_base_url
    'https://api-staging.1self.co/v1/streams'
  end

  def one_self_manifest_filename
    '1self_manifest.json'
    
  end
  
  def app_key # temporary
    'app-id-9bb5f1c77f0df722a9b1bc650a41988a'
  end
  
  def app_secret # temporary
    'app-secret-70ddd9b5cd842c9747246a5510d831b0fd18110d9bbb487d3e276f1a1c31b448'
  end
  
end


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# visible_files
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# equivalent to tags[-1].visible_files but much easier
# to test (faking files is easier than faking git)
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# active?
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# o) Players sometimes start an extra avatar solely to read the
#    instructions. I don't want these avatars appearing on the
#    dashboard.
# o) When forking a new kata you can enter as one animal
#    to sanity check it is ok (but not press [test])
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -




