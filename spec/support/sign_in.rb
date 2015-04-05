RSpec.shared_context "sign_in", :a => :b do
	before(:each) do
	    Capybara.default_host = 'http://demo.trackman.dev'
	    #company = Company.find_or_create_by(name: "demo", subdomain: "demo", plan_id: 1, time_zone: "Copenhagen")
	    company = Company.first
	    ActsAsTenant.current_tenant = company
	    @user = FactoryGirl.create(:manager, company: company) 
	    login_as @user, scope: :user   
  	end
end