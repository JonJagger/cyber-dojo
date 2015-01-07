
class FinishedController < ApplicationController

  def index
    @title = 'home'

    Thread.current[:katas_path] = root_path + '/finished/'
    katas = Dojo.new.katas

    @katas = [
      katas['898E24E7ED']
    ]
  end


end
