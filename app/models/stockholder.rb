class Stockholder < ActiveRecord::Base
  has_one :identity
  belongs_to :identity
  
  mount_uploader :copy_passport, PassportUploader
  mount_uploader :copy_signature, PassportUploader
  
  validates_presence_of :name_zh, :passport
end
