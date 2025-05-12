class Admin::BaseController < ApplicationController
  layout "admin/admin_layout"
  before_action :require_admin!

  def dashboard
  end

  private

  def require_admin!
    unless Current.user&.role == "admin"
      redirect_to root_path, alert: "Access denied."
    end
  end
end
