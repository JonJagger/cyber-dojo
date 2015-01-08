class CreateAvatarSessions < ActiveRecord::Migration
  def change
    create_table :avatar_sessions do |t|
      t.string :avatar
      t.integer :vote_count
      t.integer :fork_count
      t.references :dojo_start_point, index: true

      t.timestamps
    end
  end
end
