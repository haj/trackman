# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :car do
    mileage 1.5
    numberplate "MyString"
    car_model_id 1
    car_type_id 1
    registration_no "MyString"
    year 1
    color "MyString"
    group_id 1
  end
end
