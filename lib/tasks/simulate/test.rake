namespace :yo do
	task :rake, [:message]  => :environment  do |t, args|  	
		puts User.find(args.message).to_json
  	end
end