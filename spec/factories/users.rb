# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)
#  password               :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  company_id             :integer
#  invitation_token       :string(255)
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  invitations_count      :integer          default(0)
#  roles_mask             :integer
#  car_id                 :integer
#  first_name             :string(255)
#  last_name              :string(255)
#

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
