class UsersController < ApplicationController

  def show
    respond_with(current_user)
  end

  def update
    current_user.update(user_params) if params[:user]
    respond_with(current_user) do |format|
       format.html { render :show }
    end
  end

  private

  def user_params
    params.require(:user).permit(:avatar)
  end
end
