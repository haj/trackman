class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

    ROLES = ["admin", "manager", "employee", "driver"]

	acts_as_tenant(:company)
	validates_uniqueness_to_tenant :email
	belongs_to :company

	include RoleModel
	roles(ROLES.map(&:to_sym))

end
