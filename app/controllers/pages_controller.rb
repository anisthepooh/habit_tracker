class PagesController < ApplicationController
  layout "unauthorised"

  allow_unauthenticated_access only: :home
  def home
    redirect_to habits_path if authenticated?
  end

  def privacy_policy
  end
end
