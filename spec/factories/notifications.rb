FactoryGirl.define do
  factory :notification do
    user nil
sender_id 1
notificationable_id 1
notificationable_type "MyString"
action "MyString"
is_read false
  end

end
