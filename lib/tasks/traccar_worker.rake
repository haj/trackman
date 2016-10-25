require_relative '../../app/workers/traccar_worker'
require_relative '../../app/workers/traccar_location_worker'

task :traccar_work => :environment do
  TraccarWorker.perform_async
end

task :traccar_location_work => :environment do
  TraccarLocationWorker.perform_async
end
