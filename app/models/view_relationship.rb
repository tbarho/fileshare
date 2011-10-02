class ViewRelationship < ActiveRecord::Base
  attr_accessible :user_id

  belongs_to :viewable, :polymorphic => true
  belongs_to :user, :class_name => "User"

  validates :user_id, :viewable_id, :viewable_type, :presence => true

  validate :user_cannot_own_viewable_resource, :duplicate_entries_cannot_exist

  private

  def user_cannot_own_viewable_resource
    if self.viewable && self.user_id == self.viewable.owner_id
      errors.add(:user_id, "must not be the owner of the viewable resource")
    end
  end

  def duplicate_entries_cannot_exist
    existing = ViewRelationship.where("user_id = ? AND viewable_type = ? AND viewable_id = ?", self.user_id, self.viewable_type, self.viewable_id).exists?
    if existing
      errors.add(:user_id, "#{self.user_id} can already view #{self.viewable_type} #{self.viewable_id}")
    end
  end

  

end
