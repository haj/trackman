class FillStartPointInLocation < ActiveRecord::Migration
  def change

    Location.all.each do |l|
    	previous_location = Location.where('device_id like ?', l.device_id).where('time < ?', l.time).last
        if !previous_location.nil? and l.valid
    		time_diff = Time.diff(previous_location.time, l.time)
    		if time_diff[:minute] > 5 and previous_location.speed == 0
    			l.start_point = true
                l.save!
            else
                l.start_point = false
                l.save!
            end
        end
    end

  end
end
