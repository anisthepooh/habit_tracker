class PagesController < ApplicationController
  layout "unauthorised"

  allow_unauthenticated_access
  def home
    return if params[:admin]
    redirect_to habits_path if authenticated?
  end

  def change_log
    @changelog_entries = ChangelogEntry.published.order(date: :desc)
  end

  def become_beta
  end

  def privacy_policy
  end
end
