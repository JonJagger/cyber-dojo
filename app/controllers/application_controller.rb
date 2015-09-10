
def rooted(filename)
  root = File.absolute_path(File.dirname(__FILE__) + '/../../')
  root + '/' + filename
end

load rooted('all.rb')

class ApplicationController < ActionController::Base

  protect_from_forgery

  def dojo; @dojo ||= Dojo.new; end
  def languages; dojo.languages; end
  def exercises; dojo.exercises; end
  def katas; dojo.katas; end  
  def disk; dojo.disk; end
  def one_self; dojo.one_self; end
  
  def id; @id ||= complete_kata_id(params[:id]); end
  def kata; katas[id]; end
  def avatars; kata.avatars; end
  def avatar_name; params[:avatar]; end
  def avatar; avatars[avatar_name]; end
  def was_tag; params[:was_tag]; end
  def now_tag; params[:now_tag]; end

private
  
  def complete_kata_id(id)
    if !id.nil? && id.length >= 4
      id.upcase!
      outer_dir = disk[katas.path + id[0..1]]
      if outer_dir.exists?
        dirs = outer_dir.each_dir.select { |inner_dir| inner_dir.start_with?(id[2..-1]) }
        id = id[0..1] + dirs[0] if dirs.length === 1
      end
    end
    id || ''
  end

end
