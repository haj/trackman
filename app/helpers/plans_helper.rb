module PlansHelper
	def is_current_plan(plan)
		current_user.company.plan.plan_type.id == plan.plan_type.id 
	end
end
