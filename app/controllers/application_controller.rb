class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  helper_method :breadcrumbs

  def breadcrumbs
    @breadcrumbs ||= []
  end

  def add_breadcrumb(name, path = nil)
    breadcrumbs << Breadcrumb.new(name, path)
  end

  def set_path(path, title = nil)
    @path = path
    @title = title
  end

  protected

  def flash_with_icon(type, message, icon = nil, delay: 0)
    flash[type] = icon ? { message: message, icon: icon, delay: delay } : message
  end

  def redirect_to_after_signup_if_incomplete
    if authenticated? && Current.user && !Current.user.after_signup_completed?
      # Skip redirect if already in after_signup flow
      unless controller_name == "after_signup"
        redirect_to after_signup_path(:info)
        return true
      end
    end
    false
  end
end
