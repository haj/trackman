



# # Rule : Car starts moving
# car_moving = Rule.create!(name: "Is Moving", method_name: "starts_moving")

# # Rule : Car going faster than a particular speed
# going_faster = Rule.create!(name: "Is Goin Faster Than", method_name: "going_faster_than")
# Parameter.create!(name: "speed", data_type: "float", rule_id: going_faster.id)

# # Rule : Car going slower than a particular speed
# slower_than = Rule.create!(name: "Going slower than", method_name: "going_slower_than")
# Parameter.create!(name: "speed", data_type: "integer", rule_id: slower_than.id)

# # Rule : Car entered a particular area
# entered_area = Rule.create!(name: "Entered area", method_name: "entered_an_area")
# Parameter.create!(name: "region_id", data_type: "integer", rule_id: entered_area.id)

# # Rule : Car left a particular area
# left_area = Rule.create!(name: "Car Left Area", method_name: "left_an_area")
# Parameter.create!(name: "region_id", data_type: "integer", rule_id: left_area.id)

# # Rule : Driver been using the car for long hours
# long_hours = Rule.create!(name: "Driver using car for long hours", method_name: "driving_consecutive_hours")
# Parameter.create!(name: "scope", data_type: "integer", rule_id: long_hours.id)
# Parameter.create!(name: "threshold", data_type: "integer", rule_id: long_hours.id)

# # Rule : Driver stopped for more than X minutes in the last Y hours
# stopped_more_than = Rule.create!(name: "Stopped for more than", method_name: "stopped_for_more_than")
# Parameter.create!(name: "threshold", data_type: "integer", rule_id: stopped_more_than.id)
# Parameter.create!(name: "scope", data_type: "integer", rule_id: stopped_more_than.id)


