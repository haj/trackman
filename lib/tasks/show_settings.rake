namespace :settings do
	task :show => :environment do
		Settings.all.each do |setting|
			p "#{setting[:var]} : #{setting[:value]}"
		end
	end
end