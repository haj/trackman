require_relative '../../app/workers/traccar_worker'

task :traccar_work => :environment do
  TraccarWorker.perform_async
end
