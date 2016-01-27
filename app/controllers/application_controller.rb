
def rooted(filename)
  root = File.absolute_path(File.dirname(__FILE__) + '/../../')
  root + '/' + filename
end

require 'json'
load rooted('lib/all.rb')
load rooted('app/helpers/all'
load rooted('app/lib/all'
load rooted('app/models/all'

class ApplicationController < ActionController::Base

  protect_from_forgery

  def dojo; @dojo ||= Dojo.new; end

  def languages; dojo.languages; end
  def exercises; dojo.exercises; end
  def     katas; dojo.katas    ; end

  def id         ; params[:id     ]; end
  def avatar_name; params[:avatar ]; end
  def was_tag    ; params[:was_tag]; end
  def now_tag    ; params[:now_tag]; end

  def kata       ; katas[id]           ; end
  def avatars    ; kata.avatars        ; end
  def avatar     ; avatars[avatar_name]; end

end
