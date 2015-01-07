
class FinishedController < ApplicationController

  def index
    @title = 'home'

    Thread.current[:finished_path] = root_path + '/finished/'
    @finished = Dojo.new.finished_katas.each.entries
  end


end
