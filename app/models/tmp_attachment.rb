class TmpAttachment < ActiveRecord::Base
	# INIT GEM
  mount_uploader :file, AttachmentUploader

  # RELATIONSHIP
	has_one :attachment, dependent: :destroy
	
	# METHODS

	#
	# Retrieve File Name
  #
  def file_name
    File.basename(file_url || '')
  end

  #
  # Retrieve XML file (data)
  #
  def retrieve_xml
    file = File.open("public/#{self.file_url}")
    xml  = Nokogiri::XML(file)
    xml.children.children rescue false  		
	end
end
