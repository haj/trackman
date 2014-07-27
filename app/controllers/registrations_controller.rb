class RegistrationsController < Devise::RegistrationsController
	
	before_filter :configure_permitted_parameters
	before_filter :set_current_tenant, only: [:create]

	def set_current_tenant
		company = Company.new(company_params)
		company.save!
		ActsAsTenant.current_tenant = company
	end

	def create
		build_resource(sign_up_params)
		resource.roles << :manager
		resource_saved = resource.save

		if resource_saved
			if resource.active_for_authentication?
				#set_flash_message :notice, :signed_up if is_flashing_format?
				#sign_up(resource_name, resource)
				respond_with resource, location: after_sign_up_path_for(resource)
			else
				set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
				expire_data_after_sign_in!
				respond_with resource, location: after_inactive_sign_up_path_for(resource)
			end
		else
			clean_up_passwords resource
			respond_with resource
		end
	end

	def company_params
      params.require(:company).permit(:name, :subdomain)
    end

    def after_sign_in_path_for(resource)
	  root_url(subdomain: resource.subdomain)
	end

	protected

		def configure_permitted_parameters
			devise_parameter_sanitizer.for(:sign_up) do |u|
			  u.permit(:first_name, :last_name,
			    :email, :password, :password_confirmation)
			end
			devise_parameter_sanitizer.for(:account_update) do |u|
			  u.permit(:first_name, :last_name,
			    :email, :password, :password_confirmation, :current_password)
			end
		end


end