class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include PublicActivity::StoreController

  # Rescue cancancan
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path, :alert => exception.message
  end

  
  helper_method :current_tenant
  helper_method :js_class_name
  helper_method :css_class_name

  before_filter :set_current_tenant
  before_filter :bootstrap

  # before_filter :configure_permitted_parameters, if: :devise_controller?

  #around_filter :user_time_zone

  def js_class_name
    action = case action_name
      when 'create' then 'New'
      when 'update' then 'Edit'
    else action_name
    end.camelize
    "Views.#{self.class.name.gsub('::', '.').gsub(/Controller$/, '')}.#{action}View"
  end

    def css_class_name
    action = case action_name
      when 'create' then 'New'
      when 'update' then 'Edit'
    else action_name
    end
    "#{self.class.name.gsub('::', '.').gsub(/Controller$/, '')}#{action}"
  end

  # This will set the current tenant manually depending on the subdomain
  def set_current_tenant
    company = Company.where(subdomain: request.subdomains.last).first
    if subdomain_present? && !company.nil?
      ActsAsTenant.current_tenant = company
      logger.debug "subdomain_present? && company exists"
    elsif current_user_present?
      ActsAsTenant.current_tenant = current_user.company
      logger.warn "current_user_present? : #{current_user.name}"
      redirect_to root_url(subdomain: ActsAsTenant.current_tenant.subdomain)
    elsif !subdomain_present? || request.subdomains.last == 'www'
      #logger.warn "user wanna sign up"
    else
      #ActsAsTenant.current_tenant = nil
      logger.warn "ActsAsTenant.current_tenant is nil #{ActsAsTenant.current_tenant}"
      render :file => 'public/404.html', :status => :not_found, :layout => false
    end
  end

  def bootstrap
    gon.resource = nil
    if current_user && current_user.company
      @notifications = current_user.try(:company).try(:alarm_notifications).where(archived: false).limit(6)
      if @notifications.nil?
        return Array.new
      end
    end
  end

  # devise
  before_filter do
		resource = controller_name.singularize.to_sym
		method = "#{resource}_params"
		params[resource] &&= send(method) if respond_to?(method, true)
	end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def subdomain_present?
    !request.subdomains.last.nil?
  end

  def current_user_present?
    !current_user.nil?
  end

  def test_exception_notifier
    raise 'This is for testing exception notification gem.'
  end

  def current_tenant
    ActsAsTenant.current_tenant
  end

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation) }
  # end
  def user_time_zone(&block)
    if current_user && !current_user.company.nil? && !current_user.company.time_zone.nil?
      Time.use_zone(current_user.company.time_zone, &block)
    else
      Time.use_zone("UTC", &block)
    end
  end
  
  layout :guest_user_layout

  private



    def guest_user_layout
      if current_user.nil?
        "guest"
      else
        "application"
      end
    end

end
