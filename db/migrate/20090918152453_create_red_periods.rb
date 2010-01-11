class CreateRedPeriods < ActiveRecord::Migration
  def self.up
    create_table :red_periods, :force => true do |t| 
      t.datetime :start
      t.datetime :finish
      t.string :game_id
      t.string :country
      t.integer :inc

      t.timestamp
    end
  end

  def self.down
    drop_table :red_periods
  end
end
