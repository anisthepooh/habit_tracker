class PagesController < ApplicationController
  layout "unauthorised"

  allow_unauthenticated_access
  def home
    redirect_to habits_path if authenticated?
  end

# app/controllers/pages_controller.rb
def change_log
  @changelog_entries = ChangelogEntry.published.order(date: :desc)
end


  def privacy_policy
    set_path user_path(Current.user)
  end
end
