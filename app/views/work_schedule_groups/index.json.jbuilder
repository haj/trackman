json.array!(@work_schedule_groups) do |work_schedule_group|
  json.extract! work_schedule_group, :id, :company_id, :work_schedule_id
  json.url work_schedule_group_url(work_schedule_group, format: :json)
end
