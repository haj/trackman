class BillingsController < ApplicationController

	def confirm
		@plan = Plan.find(params[:id])
	end

	def create
		render text: "yo"
		
		#process payment here

	end

end
