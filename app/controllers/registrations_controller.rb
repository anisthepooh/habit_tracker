class RegistrationsController < ApplicationController
  layout "unauthorised"
  allow_unauthenticated_access

  def new
    @user = User.new()
  end

  def create
    group = Group.create!
    user = group.users.build(user_params)

    if user.save
      start_new_session_for user
      redirect_to edit_user_path(user), notice: "Successfully signed up!"
    else
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:email_address, :password,)
  end
end
