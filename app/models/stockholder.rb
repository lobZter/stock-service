class Stockholder < ActiveRecord::Base
  mount_uploader :copy_passport, PassportUploader
  mount_uploader :copy_signature, PassportUploader
end
