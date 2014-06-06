class UsersController < ApplicationController
  before_action :set_user, only: [:show, :destroy, :update, :edit]

  
  def create
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conversation_params
      params.require(:conversation).permit(:body, :subject, :user_id)
    end
end
