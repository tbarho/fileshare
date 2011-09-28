class Folder < ActiveRecord::Base
  attr_accessible :name

  belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"

  validates :owner_id, :name, :presence => true
  validates :name, :length => { :maximum => 50 }
end
