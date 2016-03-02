class Stockholder < ActiveRecord::Base
  has_one :identity
  
  mount_uploader :copy_passport, PassportUploader
  mount_uploader :copy_signature, PassportUploader
end
