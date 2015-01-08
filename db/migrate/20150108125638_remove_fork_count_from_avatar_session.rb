class RemoveForkCountFromAvatarSession < ActiveRecord::Migration
  def change
    remove_column :avatar_sessions, :fork_count, :integer
  end
end
