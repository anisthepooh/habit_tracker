class Admin::DashboardController < Admin::BaseController
  before_action :set_breadcrumbs
  def index
    add_breadcrumb("Dashboard", admin_dashboard_path)
    @users = User.all.order(created_at: :desc)
  end



  private

  def set_breadcrumbs
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email_address, :role)
  end
end
