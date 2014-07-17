
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
  { id: 1, name: "Is Moving", method_name: "starts_moving" }
)

# Too Fast

Rule.seed(:id,
  { id: 2, name: "Is Goin Faster Than", method_name: "going_faster_than" }
)

Parameter.seed(:id,
  { id: 1, name: "speed", data_type: "float", rule_id: 2 }
)

# Too Slow

Rule.seed(:id,
  { id: 3, name: "Going slower than", method_name: "going_slower_than" }
)

Parameter.seed(:id,
  { id: 2, name: "speed", data_type: "integer", rule_id: 3 }
)

# In

Rule.seed(:id,
  { id: 4, name: "Entered area", method_name: "entered_an_area" }
)

Parameter.seed(:id,
  { id: 3, name: "region_id", data_type: "integer", rule_id: 4 }
)

# Out 

Rule.seed(:id,
  { id: 5, name: "Car Left Area", method_name: "left_an_area" }
)

Parameter.seed(:id,
  { id: 4, name: "region_id", data_type: "integer", rule_id: 5 }
)

# Long Drive

Rule.seed(:id,
  { id: 6, name: "Driver using car for long hours", method_name: "driving_consecutive_hours" }
)

Parameter.seed(:id,
  { id: 5, name: "scope", data_type: "integer", rule_id: 6 },
  { id: 6, name: "threshold", data_type: "integer", rule_id: 6 }
)


# Long Pause

Rule.seed(:id,
  { id: 7, name: "Stopped for more than", method_name: "stopped_for_more_than" }
)

Parameter.seed(:id,
  { id: 7, name: "threshold", data_type: "integer", rule_id: 7 },
  { id: 8, name: "scope", data_type: "integer", rule_id: 7 }
)


