class TraccarWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  sidekiq_options queue: "traccar"

  def perform(params)
    Location.get_traccar_data params
  end

end