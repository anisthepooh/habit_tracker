class RegistrationsController < ApplicationController
  layout "sign_in_layout"
  allow_unauthenticated_access

  def new
    @user = User.new()
  end

  def create
    user = User.new(user_params)

    if user.save
      start_new_session_for user
      redirect_to edit_user_path(user, new_user: true), notice: "Successfully signed up!"
    else
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:email_address, :password,)
  end
end
