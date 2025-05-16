class Admin::UsersController < Admin::BaseController
  def index
    @users = User.all.order(created_at: :desc)
    add_breadcrumb("Users", admin_users_path)
  end

  def show
    @user = User.find(params[:id])
    add_breadcrumb("Users", admin_users_path)
    add_breadcrumb(@user.first_name, admin_user_path)
  end

  def edit
    @user = User.find(params[:id])
    add_breadcrumb("Users", admin_users_path)
    add_breadcrumb("Edit", edit_admin_user_path)
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "User updated."
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email_address, :role)
  end
end
