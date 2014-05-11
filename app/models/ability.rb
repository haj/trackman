class Ability
  include CanCan::Ability

  #Tutorial 
  #http://railscasts.com/episodes/192-authorization-with-cancan

  def initialize(user)
        @user = user || User.new # for guest
        @user.roles.each { |role| send(role) }

        #can :read, Page
        
        if @user.has_role? :admin 
          admin
        
        elsif @user.has_role? :manager 
          manager

        elsif @user.has_role? :employee 
          employee

        elsif @user.has_role? :driver
          driver

        end
        # See the wiki for details:
        # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end

  def admin 
    manager 
     
    can :dashboard
    can :manage, :all
  end

  def manager
    can :access, :rails_admin
    can :dashboard
    can :invite, User
    employee 
    # can :manage, [Device, Car, Simcard]
    can :read, Company, :id => @user.company_id
    can :update, Company, :id => @user.company_id
  end

  def employee
    # can :read, [Car, Device, Simcard]
    # can :read, [CarModel, CarType, CarManufacturer]
    # can :read, [DeviceType, DeviceModel, DeviceManufacturer, Teleprovider]
  end

  def driver
    can :manage, User, :id => @user.id
  end



end
