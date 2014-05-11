FactoryGirl.define do 
    factory :member do
      first_name 'zak'
      last_name "BK"

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