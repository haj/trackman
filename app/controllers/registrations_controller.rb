class RegistrationsController < Devise::RegistrationsController
	
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

end