class Folder < ActiveRecord::Base
  attr_accessible :name, :parent

  belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"
  belongs_to :parent, :class_name => "Folder", :foreign_key => "parent_id"

  has_many :folders, :class_name => "Folder", :foreign_key => "parent_id"

  has_many :view_relationships, :as => :viewable, :dependent => :destroy
  has_many :viewers, :through => :view_relationships, :source => :user

  validates :owner_id, :name, :presence => true
  validates :name, :length => { :maximum => 50 }

  def make_viewable!(viewer)
    view_relationships.create!(:user_id => viewer.id)
  end

end
