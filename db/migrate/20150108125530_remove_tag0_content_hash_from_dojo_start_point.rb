class RemoveTag0ContentHashFromDojoStartPoint < ActiveRecord::Migration
  def change
    remove_column :dojo_start_points, :tag0_content_hash, :string
  end
end
