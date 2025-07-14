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
end
