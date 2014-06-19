json.array!(@work_hours) do |work_hour|
  json.extract! work_hour, :id, :day_of_week, :starts_at, :ends_at, :device_id
  json.url work_hour_url(work_hour, format: :json)
end
