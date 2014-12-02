RSpec.shared_context "sign_out", :a => :b do
  	after(:all) do
    	logout(:user)
    	ActsAsTenant.current_tenant = nil
  	end
end