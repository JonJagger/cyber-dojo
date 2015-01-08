class CreateTrafficLights < ActiveRecord::Migration
  def change
    create_table :traffic_lights do |t|
      t.integer :tag
      t.string :content_hash
      t.integer :fork_count
      t.references :AvatarSession, index: true

      t.timestamps
    end
  end
end
