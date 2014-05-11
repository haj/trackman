class Device < ActiveRecord::Base

	def last_position
		TDevice.where(uniqueId: self.emei).first.last_position
	end
	
end
