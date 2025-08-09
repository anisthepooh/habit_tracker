class RegistrationsController < ApplicationController
  layout "sign_in_layout"
  allow_unauthenticated_access

  def new
    @user = User.new()
  end

  def create
    user = User.new(user_params)

    if user.save
      # Send welcome email
      WelcomeNotification.with(user: user).deliver(user)
      
      start_new_session_for user
      redirect_to after_signup_path(:info), notice: "Welcome! Let's complete your profile."
    else
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:email_address, :password,)
  end
end
