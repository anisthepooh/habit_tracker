class Admin::DashboardController < Admin::BaseController
  def index
    @users = User.all.order(created_at: :desc)
  end



  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email_address, :role)
  end
end
