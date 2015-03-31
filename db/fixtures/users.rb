# seed admin user

PlanType.seed(:id,
  { :id => 1, :name => "Free" },
  { :id => 2, :name => "Premium" },
)

Plan.seed(:id,
  { :id => 1, plan_type_id: 1, interval: "30", currency: "USD", price: 0.0, paymill_id: nil },
  { :id => 2, plan_type_id: 2, interval: "30", currency: "USD", price: 11.0, paymill_id: "offer_dcbf39440325852d36a6" },
)

Company.seed(:id,
  {id: 1, name: "demo", subdomain: "demo", plan_id: 1}
)

ActsAsTenant.current_tenant = Company.find(1)

User.seed(:id,
  {
  	id: 1,
  	first_name: "zak", 
  	last_name: "bk",
  	email: "zak@bk.sample", 
  	password: "foobar", 
  	password_confirmation: "foobar",  
  	current_sign_in_at: "2014-07-17 15:02:15", 
  	last_sign_in_at: "2014-07-17 15:02:15", 
  	current_sign_in_ip: "127.0.0.1", 
  	last_sign_in_ip: "127.0.0.1", 
  	roles_mask: 3
  }
)