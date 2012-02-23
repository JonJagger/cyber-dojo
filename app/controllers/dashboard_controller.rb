
class DashboardController < ApplicationController
   
  # I'd like the dashboard for a finished kata to be pure client side.
  # Create all diffs for all increments for all animals, together with
  # a client-side dashboard in a single html file.
  # This will allow a replay of a session to happen without any interaction
  # with the server. I plan to introduce the fixed timeout only when
  # you can start a new kata from any traffic-light.

  def show
    @title = 'Review'
    board_config(params)
    @seconds_per_column = seconds_per_column
    @maximum_columns = maximum_columns
  end

  def heartbeat
    board_config(params)
    @seconds_per_column = seconds_per_column
    @maximum_columns = maximum_columns
    respond_to do |format|
      format.js if request.xhr?
    end
  end
  
  def seconds_per_column
    positive(:seconds_per_column, 30)
  end
  
  def maximum_columns
    positive(:maximum_columns, 40)
  end

  def positive(symbol, default)
    value = params[symbol].to_i
    value > 0 ? value : default    
  end
  
end
