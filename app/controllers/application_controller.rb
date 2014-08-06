class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_tenant

  around_filter :user_time_zone, if: :current_user

  # set_current_tenant
  before_filter do


    if subdomain_present?
      ActsAsTenant.current_tenant = Company.where(subdomain: request.subdomains.last).first
    elsif current_user_present?
      ActsAsTenant.current_tenant = current_user.company
      redirect_to root_url(subdomain: ActsAsTenant.current_tenant.subdomain)
    else

    end

    # # if user not logged in and no subdomain -> current_tenant should be nil
    # if !current_user_present? && !subdomain_present?
    #   ActsAsTenant.current_tenant = nil
    #   logger.warn "user not logged in and no subdomain"
    # end

    # # if user not logged in and subdomain present -> current_tenant should be subdomain
    # if !current_user_present? && subdomain_present?
    #   ActsAsTenant.current_tenant = Company.where(subdomain: request.subdomains.last).first
    #   logger.warn "user not logged in and subdomain present / subdomain: #{request.subdomains.last}"
    # end

  end

  def subdomain_present?
    !request.subdomains.last.nil?
  end

  def current_user_present?
    !current_user.nil?
  end

  # cancan
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  # devise
  before_filter do
		resource = controller_name.singularize.to_sym
		method = "#{resource}_params"
		params[resource] &&= send(method) if respond_to?(method, true)
	end

  before_filter do 
    if current_user
      @notifications = User.find(current_user.id).mailbox.notifications
    end
  end

  def test_exception_notifier
    raise 'This is for testing exception notification gem.'
  end

  layout :guest_user_layout

  private

    def user_time_zone(&block)
      if !current_user.company.nil? && !current_user.company.time_zone.nil?
        Time.use_zone(current_user.company.time_zone, &block)
      end      
    end

    def guest_user_layout
      if current_user.nil?
        "guest"
      else
        "application"
      end
    end

    def current_tenant
      ActsAsTenant.current_tenant
    end

end
