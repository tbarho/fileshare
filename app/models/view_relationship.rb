class ViewRelationship < ActiveRecord::Base
  attr_accessible :user_id

  belongs_to :viewable, :polymorphic => true
  belongs_to :user, :class_name => "User"
end
