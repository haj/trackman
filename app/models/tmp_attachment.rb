class TmpAttachment < ActiveRecord::Base
	# INIT GEM
  mount_uploader :file, AttachmentUploader

  # RELATIONSHIP
	has_one :attachment, dependent: :destroy
	
	# METHODS
  def file_name
    File.basename(file_url || '')
  end
end
