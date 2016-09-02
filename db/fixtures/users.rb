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
  {id: 1, name: "demo", subdomain: "demo", plan_id: 1, time_zone: "Copenhagen"}
)

ActsAsTenant.current_tenant = Company.find(1)

User.seed(:id,
  {
  	first_name: "zak", 
  	last_name: "bk",
  	email: "zak@bk.com", 
  	password: "securepassword", 
  	password_confirmation: "securepassword",  
  	roles_mask: 3,
    confirmed_at: Time.now
  }
)


User.seed(:id,
  {
    first_name: "admin", 
    last_name: "admin",
    email: "admin@trackman.com", 
    password: "admin", 
    password_confirmation: "admin",  
    roles_mask: 1,
    confirmed_at: Time.now
  }
)