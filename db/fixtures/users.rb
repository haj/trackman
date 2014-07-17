# seed admin user

PlanType.seed(:id,
  { :id => 1, :name => "Free" },
)

Plan.seed(:id,
  { :id => 1, plan_type_id: 1, interval: "30", currency: "USD", price: 0.0, paymill_id: nil },
)

Company.seed(:id,
  {id: 1, name: "demo", subdomain: "demo", plan_id: 1}
)

User.seed(:id,
  {
  	id: 1,
  	first_name: "zak", 
  	last_name: "bk",
  	email: "zakaria@braksa.com", 
  	password: "foobar@1991", 
  	password_confirmation: "foobar@1991",  
  	current_sign_in_at: "2014-07-17 15:02:15", 
  	last_sign_in_at: "2014-07-17 15:02:15", 
  	current_sign_in_ip: "127.0.0.1", 
  	last_sign_in_ip: "127.0.0.1", 
  	company_id: 1, 
  	roles_mask: 3
  }
)