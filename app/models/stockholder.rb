class Stockholder < ActiveRecord::Base
  has_one :identity
  belongs_to :identity
  
  mount_uploader :copy_passport, PassportUploader
  mount_uploader :copy_signature, PassportUploader
  mount_uploader :copy_mail_addr, PassportUploader
  
  scope :deleted, -> { where("is_deleted=?", true)}
  scope :not_deleted, -> { where("is_deleted=?", false)}
  
  scope :filter_not_completed, -> { where(
    "  (copy_passport IS NULL)
    OR (copy_signature IS NULL)
    OR (copy_mail_addr IS NULL)"
  )}
  
  scope :filter_completed, -> { where.not(
    "  (copy_passport IS NULL)
    OR (copy_signature IS NULL)
    OR (copy_mail_addr IS NULL)"
  )}
  
  validates_presence_of :name_zh, :passport
  
end
