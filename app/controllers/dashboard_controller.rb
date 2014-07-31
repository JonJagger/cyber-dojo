root = '../..'

require_relative root + '/lib/TimeNow'

class DashboardController < ApplicationController

  def show
    gather
    @title = id[0..5] + ' dashboard'
    # provide these if you want to open the diff-dialog for a
    # specific [avatar,was_tag,now_tag] as the dashboard opens.
    # See also app/controllers/diff_controller.rb
    if params['avatar'] && params['was_tag'] && params['now_tag']
      @id = id
      @avatar_name = params['avatar']
      @was_tag = params['was_tag']
      @now_tag = params['now_tag']
      @max_tag = @kata.avatars[@avatar_name].lights.each.entries.length
    end
  end

  def heartbeat
    gather
    respond_to do |format|
      format.js if request.xhr?
    end
  end

  def help_dialog
    render :layout => false
  end

  def summary
    animals = { }
    dojo.katas[id].avatars.active.each do |avatar|
      animals[avatar.name] = {
        :colour => avatar.lights[-1].colour,
        :summary => most_recent_summary(avatar)
      }
    end

	render :json => {
      :animals => animals
    }
  end

private

  include TimeNow

  def gather
    @kata = dojo.katas[id]
    @minute_columns = bool('minute_columns')
    @auto_refresh = bool('auto_refresh')
    maximum_seconds_uncollapsed = seconds_per_column * 60
    gapper = TdGapper.new(@kata.created, seconds_per_column, maximum_seconds_uncollapsed)
    all_lights = Hash[
      @kata.avatars.collect{|avatar| [avatar.name, avatar.lights]}
    ]
    @gapped = gapper.fully_gapped(all_lights, time_now)
    @summary = @kata.language.summary_regexs != [ ]
  end

  def bool(attribute)
    tf = params[attribute]
    return tf if tf == 'true' || tf == 'false'
    return "true"
  end

  def seconds_per_column
    flag = params['minute_columns']
    return 60 if !flag || flag == 'true'
    return 60*60*24*365*1000
  end

  def most_recent_summary(avatar)
    regexs = avatar.kata.language.summary_regexs
    light = avatar.lights.reverse.find{|light| [:red,:green].include?(light.colour)}
    output = light.tag.output
    regexs.map{|regex| Regexp.new(regex).match(output)}.join
  end

end
