class CreateViewRelationships < ActiveRecord::Migration
  def change
    create_table :view_relationships do |t|
      t.integer :user_id
      t.integer :viewable_id
      t.string :viewable_type

      t.timestamps
    end
    add_index :view_relationships, :user_id
    add_index :view_relationships, :viewable_id
    add_index :view_relationships, :viewable_type
  end
end
