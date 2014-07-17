PlanType.seed(:id,
  { :id => 1, :name => "Free" },
)

Plan.seed(:id,
  { :id => 1, plan_type_id: 1, interval: "30", currency: "USD", price: 0.0, paymill_id: nil },
)

