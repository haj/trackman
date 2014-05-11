FactoryGirl.define do 
    factory :company do
        sequence(:name) { |n| "Company #{n}" }
        sequence(:subdomain) { |n| "subdomain#{n}" } 
    end
end