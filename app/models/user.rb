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
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :async

   	scope :by_role, -> role_name { where(roles_mask: self.mask_values_for(role_name.to_sym)) }

    ROLES = ["admin", "manager", "employee", "driver"]

    acts_as_messageable

	acts_as_tenant(:company)
	validates_uniqueness_to_tenant :email
	belongs_to :company
	belongs_to :car

	include RoleModel
	roles(ROLES.map(&:to_sym))

	def self.available_drivers
		users = User.where(:car_id => nil)
		drivers = users.select { |user| user.has_role?(:driver) } 
		return drivers
	end

	def name_with_email
		"#{self.first_name} #{self.last_name} #{self.email}" 
	end

	# These methods are required by the mailboxer gem

	def name 
		"#{self.first_name} #{self.last_name}"
	end

	def mailboxer_email(object)
	  #Check if an email should be sent for that object
	  #if true
	  return "define_email@on_your.model"
	  #if false
	  #return nil
	end

end
