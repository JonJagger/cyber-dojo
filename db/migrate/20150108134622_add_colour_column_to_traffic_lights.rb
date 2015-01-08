class AddColourColumnToTrafficLights < ActiveRecord::Migration
  def change
    add_column :traffic_lights, :colour, :string
  end
end
