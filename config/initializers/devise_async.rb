Devise::Async.setup do |config|
  config.enabled  = true
  config.backend  = :sidekiq
  config.queue    = :default
  config.priority = 3
end
