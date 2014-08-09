class Traccar::Location < ActiveRecord::Base
	belongs_to :position, :class_name => 'Traccar::Position'
end
