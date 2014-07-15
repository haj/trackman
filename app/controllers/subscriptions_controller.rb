class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:show, :edit, :update, :destroy]

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
  end

  # GET /subscriptions/new
  def new

    plan = Plan.find(params[:plan_id])
    if plan.plan_type.id == PlanType.first.id
      # if it's the free plan, cancel previous active subscriptions 
      company = current_user.company
      company.cancel_active_subscriptions

      # and switch to new free plan
      plan.companies << company

      redirect_to company
    else
      @subscription = plan.subscriptions.build
    end
    
  end

  # GET /subscriptions/1/edit
  def edit
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    @subscription = Subscription.new(params[:subscription]) 
    company = current_user.company
    
    if @subscription.save_with_payment
      # switch the current company plan
      @subscription.plan.companies << company

      # schedule to cancel all active subscriptions
      company.cancel_active_subscriptions

      # Add this subscriptions to the company list of subscriptions
      company.subscriptions << @subscription

      redirect_to @subscription, :notice => "Thank you for subscribing!"
    else
      render :new
    end
  end

  # PATCH/PUT /subscriptions/1
  # PATCH/PUT /subscriptions/1.json
  def update
    respond_to do |format|
      if @subscription.update(subscription_params)
        format.html { redirect_to @subscription, notice: 'Subscription was successfully updated.' }
        format.json { render :show, status: :ok, location: @subscription }
      else
        format.html { render :edit }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @subscription.destroy
    respond_to do |format|
      format.html { redirect_to subscriptions_url, notice: 'Subscription was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subscription_params
      params.require(:subscription).permit(:email, :name, :paymill_id, :paymill_card_token, :plan_id)
    end
end
