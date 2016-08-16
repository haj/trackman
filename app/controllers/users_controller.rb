class UsersController < ApplicationController
  # Include module / class
  include Batchable

  load_and_authorize_resource

  has_scope :by_role

  # Callback controller
  before_action :set_user, only: [:show, :destroy, :update, :edit, :notifications]

  # GET /users || users_index_path
  def index
    @q = apply_scopes(User).all.search(params[:q])
    @users = @q.result(distinct: true)

    respond_with(@users)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_with(@user)
  end

  # GET /users/new
  def new
    @user = User.new

    respond_with(@user)
  end

  # GET /users/1/edit
  def edit
    respond_with(@user)
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      respond_with(@user, location: users_url, notice: 'User was successfully created.')
    else
      respond_with(@user)
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      respond_with(@user, location: users_url, notice: 'User was successfully updated.')
    else
      respond_with(@user)
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    respond_with(@user, location: users_url, notice: 'User was successfully destroyed.')
  end

  def notifications
    @notifications = @user.mailbox.notifications

    respond_with(@notifications)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :password_confirmation)
  end
end
