require_relative '../../app/workers/import_all_lefts_code_worker'
 
namespace :worker do
 
	task :run => :environment do
		ImportAllLeftsCodeWorker.perform_async
	end	
end