class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update ]

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Profile updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :username,
      :bio,
      :avatar_url,
      :admin,
      :group_id
    )
  end
end
