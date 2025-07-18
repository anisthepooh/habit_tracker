class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :new_user ]

  def show
    set_path habits_path, "Back to habits"
    @user = User.find(params[:id])
  end

  def edit
    set_path user_path(@user), "Back to profile"
  end

  def new_user
  end

  def update
    @user.build_user_configuration unless @user.user_configuration
    if @user.update(user_params)
      if params[:new_user]
        WelcomeNotification.with(user: @user).deliver(@user)
      end
      flash_with_icon(:notice, "Profile updated successfully!", "check-circle")
      redirect_to @user
    else
      flash_with_icon(:alert, "There was an error updating your profile.", "alert-circle")
      render :edit, status: :unprocessable_entity
    end
  end

  def report
    @user = User.find(params[:user_id])
    set_path user_path(@user), "Back to profile"

    @entries_count = @user.entries.count
    @first_entry = @user.entries.order(:created_at).first
    @habits_count = @user.habits.count
    @first_habit =@user.habits.order(:created_at).first
    @most_mood = @user.entries.group(:mood).order("count_id DESC").count(:id).first
    @habits_completed_count = @user.habits.where(archived: "true").count
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
      :remove_avatar,
      :card_background
    )
  end
end
