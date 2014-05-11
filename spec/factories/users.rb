FactoryGirl.define do 
    factory :user do
    	sequence(:email) { |n| "zak#{n}@example.com" }
        password "password"
        password_confirmation "password"
        #confirmed_at Time.now
		association :company, factory: :company
    end

end