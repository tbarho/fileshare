class AddOwnerIdToFolders < ActiveRecord::Migration
  def change
    add_column :folders, :owner_id, :integer
  end
end
