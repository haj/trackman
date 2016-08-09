class InvitationsController < DeviseController
  # Callback controller
  prepend_before_filter :authenticate_inviter!, :only => [:new, :create]
  prepend_before_filter :has_invitations_left?, :only => [:create]
  prepend_before_filter :require_no_authentication, :only => [:edit, :update, :destroy]
  prepend_before_filter :resource_from_invitation_token, :only => [:edit, :destroy]
  before_filter :set_current_tenant, :only => :create
  helper_method :after_sign_in_path_for


  # GET /resource/invitation/new
  def new
    self.resource = resource_class.new
    authorize! :invite, self.resource
    render :new
  end

  # POST /resource/invitation
  def create
    self.resource = invite_resource

    if resource.errors.empty?
      yield resource if block_given?

      self.resource.first_name = params[:first_name]
      self.resource.last_name = params[:last_name]

      if params[:default_role] == "Driver"
        self.resource.roles << :driver
        self.resource.save
      elsif params[:default_role] == "Employee"
        self.resource.roles << :employee
        self.resource.save
      elsif params[:default_role] == "Manager"
        self.resource.roles << :manager
        self.resource.save
      end

      # Fix invitation email 
      User.invite!(:email => self.resource.email, :first_name => params[:first_name], last_name: params[:last_name])

      set_flash_message :notice, :send_instructions, :email => self.resource.email if self.resource.invitation_sent_at
      respond_with resource, :location => after_invite_path_for(resource)
    else
      respond_with_navigational(resource) { render :new }
    end
  end

  # GET /resource/invitation/accept?invitation_token=abcdef
  def edit
    resource.invitation_token = params[:invitation_token]
    render :edit
  end

  # PUT /resource/invitation
  def update
    self.resource = accept_resource

    if resource.errors.empty?
      yield resource if block_given?
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active                                                                                        
      #set_flash_message :notice, flash_message
      #sign_in(resource_name, resource)
      respond_with resource, :location => after_accept_path_for(resource)
    else
      respond_with_navigational(resource){ render :edit }
    end
  end
  
  # GET /resource/invitation/remove?invitation_token=abcdef
  def destroy
    resource.destroy
    set_flash_message :notice, :invitation_removed
    redirect_to after_sign_out_path_for(resource_name)
  end

  def set_current_tenant
    ActsAsTenant.current_tenant = current_user.company
  end

  protected

  def invite_resource(&block)
    resource_class.invite!(invite_params, current_inviter, &block)
  end
  
  def accept_resource
    resource_class.accept_invitation!(update_resource_params)
  end

  def current_inviter
    authenticate_inviter!
  end

  def has_invitations_left?
    unless current_inviter.nil? || current_inviter.has_invitations_left?
      self.resource = resource_class.new
      set_flash_message :alert, :no_invitations_remaining
      respond_with_navigational(resource) { render :new }
    end
  end
  
  def resource_from_invitation_token
    unless params[:invitation_token] && self.resource = resource_class.find_by_invitation_token(params[:invitation_token], true)
      set_flash_message(:alert, :invitation_token_invalid)
      redirect_to after_sign_out_path_for(resource_name)
    end
  end

  def after_accept_path_for(resource)
    root_url(subdomain: resource.subdomain)
  end

  def invite_params
    devise_parameter_sanitizer.sanitize(:invite)
  end

  def update_resource_params
    devise_parameter_sanitizer.sanitize(:accept_invitation)
  end

	def configure_permitted_parameters
		# Only add some parameters
		devise_parameter_sanitizer.for(:accept_invitation).concat [:default_role, :first_name, :last_name]
	end  
end
