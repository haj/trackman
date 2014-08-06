

FactoryGirl.define do 
    factory :user do
    	first_name 'zak'
      	last_name "bk"
    	sequence(:email) { |n| "zak#{n}@example.com" }
        password "password"
        password_confirmation "password"
        #confirmed_at Time.now
		association :company, factory: :company
    
    	factory :admin do
			roles [:admin]
		end

		factory :manager do
			roles [:manager]
		end

		factory :employee do
			roles [:employee]
		end

		factory :driver do 
			roles [:driver]
		end

    end

    

end
