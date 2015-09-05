Settings.defaults[:start_date] = DateTime.now.yesterday
Settings.defaults[:end_date] = DateTime.now
Settings.defaults[:start_time] = "00:00"
Settings.defaults[:end_time] = "23:59"
Settings.defaults[:avg_time_between_positions] = 5
Settings.defaults[:distance_between_positions] = 0.02