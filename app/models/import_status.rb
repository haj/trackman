class ImportStatus < ActiveRecord::Base
  belongs_to :position, :class_name => 'Traccar::Position', :foreign_key => 'position_id'
end
