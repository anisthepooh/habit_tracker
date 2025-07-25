class Admin::UsersController < Admin::BaseController
  def index
    @q = User.ransack(params[:q])
    @users = @q.result.order(created_at: :desc).paginate(page: params[:page], per_page: 30)

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

  def destroy
    @user = User.find(params[:id])
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to admin_users_path, status: :see_other, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email_address, :role)
  end
end
