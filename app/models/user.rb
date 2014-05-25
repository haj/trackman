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
