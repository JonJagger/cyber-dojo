
class ReviewController < ApplicationController

  def show
    @kata = kata
    @avatar_name = params[:avatar] || kata.avatars.active.map(&:name).sort[0]
    @avatar = avatars[@avatar_name]
    @was_tag = was_tag
    @now_tag = now_tag
  end

  private

  def was_tag
    tag(:was_tag, '0')
  end

  def now_tag
    tag(:now_tag, '1')
  end

  def tag(param, default)
    n = (params[param] || default).to_i
    n != -1 ? n : @avatar.lights.length
  end

end
