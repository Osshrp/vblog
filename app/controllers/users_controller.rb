class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update]

  def show
    respond_with(@user)
  end

  def update
    @user.update(user_params) if params[:user]
    respond_with(@user) do |format|
       format.html { render :show }
    end
  end

  private

  def user_params
    params.require(:user).permit(:avatar)
  end

  def set_user
    @user = current_user
  end
end
