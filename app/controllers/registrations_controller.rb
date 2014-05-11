class RegistrationsController < Devise::RegistrationsController
	
	def create
		super
		company = Company.new(company_params)
		company.save!
	end

	def company_params
      params.require(:company).permit(:name, :subdomain)
    end

end