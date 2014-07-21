class RegistrationsController < Devise::RegistrationsController
	
	before_filter :configure_permitted_parameters

	def create
		super do |resource|
			company = Company.new(company_params)
			company.save!
			resource.company_id = company.id
			resource.roles << :manager
 	  end	
	end

	def company_params
      params.require(:company).permit(:name, :subdomain)
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

	private
  	def after_sign_up_fails_path_for(resource)
   		new_user_registration_path
  	end

end