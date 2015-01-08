class CreateDojoStartPoints < ActiveRecord::Migration
  def change
    create_table :dojo_start_points do |t|
      t.string :dojo_id
      t.string :language
      t.string :exercise
      t.string :tag0_content_hash

      t.timestamps
    end
  end
end
