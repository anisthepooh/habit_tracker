class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update ]

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
    flash[:notice] = "Profile updated!"
    if @user.update(user_params)
      redirect_to @user, notice: "Profile updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def croppable
    @user = set_user
    @user.cropped_avatar.attach(
      io: StringIO.new(Base64.decode64(user_params[:cropped_avatar].split(",")[1])),
      filename: "cropped_image.jpg",
      content_type: "image/jpg"
    )
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
      :avatar,
      :cropped_avatar,
      :admin,
      :group_id,
      :remove_avatar,
      :card_background
    )
  end
end
