class EditRelationship < ActiveRecord::Base
  attr_accessible :user_id

  belongs_to :editable, :polymorphic => true
  belongs_to :user, :class_name => "User"

  validates :user_id, :editable_id, :editable_type, :presence => true

  validate :user_cannot_own_editable_resource, :duplicate_entries_cannot_exist

  private

  def user_cannot_own_editable_resource
    if self.editable && self.user_id == self.editable.owner_id
      errors.add(:user_id, "must not be the owner of the editable resource")
    end
  end

  def duplicate_entries_cannot_exist
    existing = EditRelationship.where("user_id = ? AND editable_type = ? AND editable_id = ?", self.user_id, self.editable_type, self.editable_id).exists?
    if existing
      errors.add(:user_id, "#{self.user_id} can already edit #{self.editable_type} #{self.editable_id}")
    end
  end 
end
