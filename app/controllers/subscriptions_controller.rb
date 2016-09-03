class SubscriptionsController < ApplicationController
  # Include module / class
  add_breadcrumb "Subscriptions", :subscriptions_url

  load_and_authorize_resource
  include Breadcrumbable

  # Callback controller
  before_action :set_subscription, only: [:show, :edit, :update, :destroy, :cancel]

  def index
    @subscriptions = Subscription.includes(:plan).order(created_at: :desc).page(params[:page])    
    @subscription  = current_user.company.subscriptions.active
  end
  
  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
    respond_with(@subscription)
  end

  # GET /subscriptions/new
  def new
    plan = Plan.find(params[:plan_id])

    # if it's the free plan, cancel previous active subscriptions 
    if plan.plan_type.id == PlanType.first.id
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
    respond_with(@subscription)
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    ActiveRecord::Base.transaction do
      begin
        @subscription = Subscription.new(subscription_params) 
        
        if @subscription.save
          respond_with(@subscription, location: subscriptions_path, notice: 'Thank you for subscribing!')
        else
          respond_with(@subscription)
        end
      rescue Paymill::PaymillError => e
        respond_with(e, location: :back, notice: e.message)
      rescue Paymill::APIError => e
        respond_with(e, location: :back, notice: e.message)
      rescue Paymill::AuthenticationError 
        respond_with(e, location: :back, notice: e.message)
      end
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

  # Cancel a runningsubscription
  def cancel
    @subscription.cancel

    respond_with(@subscription, location: subscriptions_url, notice: 'Subscription successfully cancel.')    
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
