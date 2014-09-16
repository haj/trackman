
# Rule.seed(:id,
#   { id: 1, name: "Is Moving", method_name: "starts_moving" },
#   { id: 2, name: "Is Goin Faster Than", method_name: "going_faster_than" },
#   { id: 3, name: "Going slower than", method_name: "going_slower_than" },
#   { id: 4, name: "Entered area", method_name: "entered_an_area" },
#   { id: 5, name: "Car Left Area", method_name: "left_an_area" },
#   { id: 6, name: "Driver using car for long hours", method_name: "driving_consecutive_hours" },
#   { id: 7, name: "Stopped for more than", method_name: "stopped_for_more_than" },
# )

# Parameter.seed(:id,
#   { id: 1, name: "speed", data_type: "float", rule_id: 2 },
#   { id: 2, name: "speed", data_type: "integer", rule_id: 3 },
#   { id: 3, name: "region_id", data_type: "integer", rule_id: 4 },
#   { id: 4, name: "region_id", data_type: "integer", rule_id: 5 },
#   { id: 5, name: "scope", data_type: "integer", rule_id: 6 },
#   { id: 6, name: "threshold", data_type: "integer", rule_id: 6 },
#   { id: 7, name: "threshold", data_type: "integer", rule_id: 7 },
#   { id: 8, name: "scope", data_type: "integer", rule_id: 7 }
# )

# Movement

Rule.seed(:id,
  { id: 1, name: "Is Moving", method_name: "starts_moving", description: "Check if Vehicle is moving during Work Schedule" }
)

# Too Fast

Rule.seed(:id,
  { id: 2, name: "Speed Limit", method_name: "speed_limit", description: "Check if Vehicle is moving during Work Schedule" }
)

Parameter.seed(:id,
  { id: 2, name: "speed", data_type: "float", rule_id: 2, description: "Speed (Km/h)" },
  { id: 10, name: "repeat_notification", data_type: "integer", rule_id: 2, description: "Notification Rate (Minutes)" }
)

# Enters area

Rule.seed(:id,
  { id: 4, name: "Entered area", method_name: "enter_area", description: "Check if Vehicle is moving during Work Schedule" }
)

Parameter.seed(:id,
  { id: 4, name: "region_id", data_type: "integer", rule_id: 4, description: "Region"  }
)

# Out 

Rule.seed(:id,
  { id: 5, name: "Car Left Area", method_name: "leave_area", description: "Check if Vehicle is moving during Work Schedule" }
)

Parameter.seed(:id,
  { id: 5, name: "region_id", data_type: "integer", rule_id: 5, description: "Region" }
)

# Long Drive

Rule.seed(:id,
  { id: 6, name: "Driver using Vehicle for long hours", method_name: "driving_consecutive_hours", description: "Check if Vehicle is moving during Work Schedule" }
)

Parameter.seed(:id,
  { id: 6, name: "threshold", data_type: "integer", rule_id: 6, 
    description: "Duration (Minutes)" }
)


# Long Pause

Rule.seed(:id,
  { id: 7, name: "Stopped for more than", method_name: "stopped_for_more_than", description: "Check if Vehicle is moving during Work Schedule" }
)

Parameter.seed(:id,
  { id: 7, name: "threshold", data_type: "integer", rule_id: 7, description: "Duration (Minutes)" },
)

# Using vehicle outside work hours

Rule.seed(:id,
  { id: 8, name: "During Work Schedule", method_name: "movement_not_authorized", description: "Check if Vehicle is moving during Work Schedule" }
)

Parameter.seed(:id,
  { id: 8, name: "repeat_notification", data_type: "integer", rule_id: 8, description: "Notification Rate (Minutes)" }
)


