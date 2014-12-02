RSpec.shared_context "sign_in", :a => :b do
	before(:each) do
	    Capybara.default_host = 'http://demo.trackman.dev'
	    company = Company.first
	    ActsAsTenant.current_tenant = company
	    @user = FactoryGirl.create(:manager, company: company) 
	    login_as @user, scope: :user   
  	end
end