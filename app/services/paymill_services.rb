class PaymillServices
  class << self

    #
    # List all subscriptions
    #
    def all_subscriptions
      Paymill::Subscription.all
    end

    #
    # Cancel a subscription
    #
    def cancel(paymill_id, subscription_id)
      Paymill::Subscription.update_attributes paymill_id, cancel_at_period_end: true
      Paymill::Subscription.delete(paymill_id)

      Subscription.find(subscription_id).update_attribute(:active, false)
    end

    #
    # Create a client
    #
    def create_client(email, name)
      Paymill::Client.create(email: email, description: name)      
    end

    #
    # Create payment
    #
    def create_payment(paymill_card_token, client_id)
      Paymill::Payment.create(token: paymill_card_token, client: client_id)
    end

    #
    # Create Subscription
    #
    def create_subscription(paymill_id, client_id, payment_id)
      Paymill::Subscription.create(offer: paymill_id, client: client_id, payment: payment_id)      
    end

  end
end
