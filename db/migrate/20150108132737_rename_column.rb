class RenameColumn < ActiveRecord::Migration
  def change
    rename_column :traffic_lights, :AvatarSession_id, :avatar_session_id
  end
end
