require "sidekiq"

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://127.0.0.1:6379/0', namespace: "sidekiq" }

  # ENV["TRACCAR_DB_URL"] = "mysql2://#{ENV['DB_USER']}:#{ENV['DB_PASSWORD']}@localhost/#{ENV['DB_TRACCAR_NAME']}?pool=5"
  # ActiveRecord::Base.establish_connection(ENV["TRACCAR_DB_URL"])

  # ENV["DB_URL"] = "mysql2://#{ENV['DB_USER']}:#{ENV['DB_PASSWORD']}@localhost/#{ENV['DB_NAME']}?pool=5"
  # ActiveRecord::Base.establish_connection(ENV["DB_URL"])

end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://127.0.0.1:6379/0', namespace: "sidekiq" }
end