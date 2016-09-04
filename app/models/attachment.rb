class Attachment < ActiveRecord::Base
	# Relationship
  belongs_to :tmp_attachment
  belongs_to :attachable, polymorphic: true
end
