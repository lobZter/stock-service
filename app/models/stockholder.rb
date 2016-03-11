class Stockholder < ActiveRecord::Base
  has_one :identity
  belongs_to :identity
  
  mount_uploader :copy_passport, PassportUploader
  mount_uploader :copy_signature, PassportUploader
  
  validates_presence_of :name_zh, :passport
  
  validate :readonly_field, :on => :update

  def readonly_field
    self.errors.add(:identity_id, "identity_id can't be changed") if self.identity_id_changed?
  end
end
