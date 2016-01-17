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

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
	include RailsSettings::Extend

	devise :invitable, :database_authenticatable, :registerable,
	:recoverable, :rememberable, :trackable, :async

	scope :by_role, -> role_name { where(roles_mask: self.mask_values_for(role_name.to_sym)) }

	acts_as_messageable

	acts_as_tenant(:company)
	validates_uniqueness_to_tenant :email
	validates :first_name, :last_name, :presence => true
	belongs_to :company
	belongs_to :car

	ROLES = %w(admin manager employee driver) #["admin", "manager", "employee", "driver"]
	include RoleModel
	roles(ROLES.map(&:to_sym))

	def self.available_drivers
		users = User.where(car_id: nil)
		return users.select { |user| user.has_role?(:driver) }
	end

	def name_with_email
		"#{self.first_name} #{self.last_name} #{self.email}"
	end

	# These methods are required by the mailboxer gem

	def subdomain
		self.company.subdomain
	end

	def name
		"#{self.first_name} #{self.last_name}"
	end

	def mailboxer_email(object)
		return self.email
	end

	def list_roles
		self.roles.join(",")
	end

	def self.recipients(user)
		User.where.not(:id => user.id)
	end

	def make_payment(plan, credit_card)
		ActiveMerchant::Billing::Base.mode = :test

		gateway = ActiveMerchant::Billing::PaypalGateway.new(
			login: "cubbyhole_api1.example.com",
			password: "1402685627",
			signature: "An5ns1Kso7MWUdW4ErQKJJJ4qi4-Arz7-U0RTw-Z.YfMJ36hjzxSotLN"
		)

		credit_card = ActiveMerchant::Billing::CreditCard.new(
			brand: credit_card.brand,
			number: credit_card.number,
			verification_value: credit_card.verification,
			month: credit_card.month,
			year: credit_card.year,
			first_name: credit_card.first_name,
			last_name: credit_card.last_name
		)

		monthly_price = plan.price * 10

		if credit_card.valid?
		  	response = gateway.recurring(monthly_price, credit_card, { :period => "Month" ,:frequency => 1, :start_date => Time.now, :description => "Cubbyhole Monthly Plan recurring payment" })
		  	if response.success?
				# change plan associated with this user
				self.update_attribute(:plan_id, plan.id)

				#create payment entry in db
				payment = Payment.new(profile_id: response.params['profile_id'], user_id: self.id)
				payment.save!

				return { success: true, message: "Purchase complete" }
		  	else
				return { success: false, message: "Error: #{response.message}" }
		  	end
		else
		  	return { success: false, message: "Error: credit card is not valid. #{credit_card.errors.full_messages.join('. ')}" }
		end
	end

	def cancel_payment(profile_id)
		ActiveMerchant::Billing::Base.mode = :test

		gateway = ActiveMerchant::Billing::PaypalGateway.new(
		  login: "cubbyhole_api1.example.com",
		  password: "1402685627",
		  signature: "An5ns1Kso7MWUdW4ErQKJJJ4qi4-Arz7-U0RTw-Z.YfMJ36hjzxSotLN"
		)

		response = gateway.cancel_recurring(profile_id)

		if response.success?
		  return { success: true, message: "Recurring payment cancelled" }
		else
		  return { success: false, message: "Recurring payment couldn't be cancelled. Reason: #{response.inspect}" }
		end
	end

	def time_zone
		return self.company.time_zone
	end

end
