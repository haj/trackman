def funcc
    Location.all.each do |l|
        if !l.previous.nil?
            duration_since_previous = (l.time - l.previous.time)
            if duration_since_previous.to_i > 300
                # A START POINT
                l.start_point = true

                # PREVIOUS POSITION
                lp = l.previous

                if !lp.start_point
                    # parking duration = interval between current position and last stop position.
                    lp.stop_point = true
                    lp.driving_duration = (l.time - l.previous_start_position.time)
                else
                    lp.stop_point = false
                end

                if l.previous_stop_position
                    duration_previous_stop_position = l.time - l.previous_stop_position.time
                    # parking duration = interval between current position and last stop position.
                    l.parking_duration = duration_previous_stop_position
                end

                lp.save!

            else
                l.start_point = false
            end
        else
            l.start_point = true
        end
        l.save!
    end
end

def make_stop_positions

    Location.all.each do |l|
        if !l.previous.nil?
            if l.start_point == true
                lp = l.previous
                lp.stop_point = true
                lp.save!
            end
        end
    end
    
end

def reset_locations
    Location.all.destroy_all
    Traccar::Position.all.each do |p|
        p.location = Location.create(address: geo.address, city: geo.city, country: geo.country, state: geo.state, device_id: position.device_id, time: position.time, speed: position.speed, valid_position: position.valid)
    end
end

def check_states
    Location.where(valid_position: true).each do |l|
        if l.speed > 0

        end
    end
end

