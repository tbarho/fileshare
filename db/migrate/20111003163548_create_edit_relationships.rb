class CreateEditRelationships < ActiveRecord::Migration
  def change
    create_table :edit_relationships do |t|
      t.integer :user_id
      t.integer :editable_id
      t.string :editable_type

      t.timestamps
    end
  end
end
