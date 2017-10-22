class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :update]

  def show
    @user ||= current_user
    respond_with(@user)
  end

  def update
    if params[:user] && @user == current_user
      @user.update(user_params)
    end
    respond_with(current_user) do |format|
       format.html { render :show }
    end
  end

  private

  def user_params
    params.require(:user).permit(:avatar)
  end

  def set_user
    @user = User.find(params[:id]) if params[:id]
  end
end
