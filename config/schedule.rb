# set :environment, "production"
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}
set :environment, "production"

every 1.minute do 
  rake "alarms:check"
  p "Check Alarms is has run!"
end

every 1.minute do
  rake "traccar_work"
end

