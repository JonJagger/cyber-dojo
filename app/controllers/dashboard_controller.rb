
class DashboardController < ApplicationController

  def show
    gather
    @title = 'dashboard'
    # provide these if you want to open the diff-history for a
    # specific [avatar,was_tag,now_tag] as the dashboard opens.
    # See also app/controllers/differ_controller.rb
    if avatar_name && was_tag && now_tag
      @id = id
      @avatar_name = avatar_name
      @was_tag = was_tag
      @now_tag = now_tag
    end
  end

  def heartbeat
    gather
    respond_to do |format|
      format.js
    end
  end

  def progress
    animals = { }
    avatars.active.each do |avatar|
      animals[avatar.name] = {
        :colour => avatar.lights[-1].colour,
        :progress => most_recent_progress(avatar)
      }
    end
    render :json => {
      :animals => animals
    }
  end

private

  include TimeNow

  def gather
    @kata = kata
    @minute_columns = bool('minute_columns')
    @auto_refresh = bool('auto_refresh')
    maximum_seconds_uncollapsed = seconds_per_column * 60
    gapper = TdGapper.new(@kata.created, seconds_per_column, maximum_seconds_uncollapsed)
    all_lights = Hash[
      @kata.avatars.each.collect{|avatar| [avatar.name, avatar.lights]}
    ]
    @gapped = gapper.fully_gapped(all_lights, time_now)
    @progress = @kata.language.progress_regexs != [ ]
    @avatar_names = all_lights.map {|name,lights|
      [lights.count, name]
    }.sort.reverse.map {|a| a[1]}
  end

  def bool(attribute)
    tf = params[attribute]
    tf == 'false' ? tf : 'true'
  end

  def seconds_per_column
    flag = params['minute_columns']
    return 60 if !flag || flag == 'true'
    return 60*60*24*365*1000
  end

  def most_recent_progress(avatar)
    regexs = avatar.kata.language.progress_regexs
    non_amber = avatar.lights.reverse.find{ |light|
      [:red,:green].include?(light.colour)
    }
    output = non_amber.tag.output
    matches = regexs.map{|regex| Regexp.new(regex).match(output)}
    return {
      :text => matches.join,
      :colour => (matches[0] != nil ? 'red' : 'green')
    }
  end

end
