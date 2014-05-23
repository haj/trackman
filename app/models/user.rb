class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :async

    ROLES = ["admin", "manager", "employee", "driver"]

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

	def name 
		return "#{self.first_name} #{self.last_name}"
	end

end
