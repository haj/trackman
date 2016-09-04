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
# x sign_in_count          :integer          default(0), not null
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
  ROLES = %w(admin manager employee driver) #["admin", "manager", "employee", "driver"]

  # Init Gem
  include RailsSettings::Extend
  include RoleModel

  devise :invitable, :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :async, :confirmable

  acts_as_messageable
  acts_as_tenant(:company)

  roles(ROLES.map(&:to_sym))

  # Scope
  scope :by_role, -> role_name { where(roles_mask: self.mask_values_for(role_name.to_sym)) }

  # Validation  
  validates_uniqueness_to_tenant :email
  validates :first_name, :last_name, :presence => true

  # AssociationU
  belongs_to :company
  belongs_to :car
  has_many :destinations_users
  has_many :orders, through: :destinations_users


  class << self
    def available_drivers
      users = User.where(car_id: nil)
      
      users.select { |user| user.has_role?(:driver) }
    end

    def recipients(user)
      User.where.not(:id => user.id)
    end
  end

  def full_name
    first_name + " " + last_name
  end

  def name_with_email
    "#{self.first_name} #{self.last_name} #{self.email}"
  end

  def subdomain
    self.company.subdomain
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def mailboxer_email(object)
    self.email
  end

  def list_roles
    self.roles.join(",")
  end

  def time_zone
    self.company.time_zone
  end
end
