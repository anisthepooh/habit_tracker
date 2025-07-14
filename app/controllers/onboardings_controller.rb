class OnboardingsController < ApplicationController
  before_action :_set_path, only: [ :create_habit, :save_to_homescreen ]
  def index
    set_path user_path(Current.user), "Back to profile"
  end

  def create_habit
    Current.user.mark_onboarding_viewed("create_habit")
  end

  def add_check_in
    Current.user.mark_onboarding_viewed("add_check_in")
  end

  def save_to_homescreen
    Current.user.mark_onboarding_viewed("save_to_homescreen")
  end

  def mark_completed
    guide_name = params[:guide_name]
    if guide_name.present?
      Current.user.mark_onboarding_completed(guide_name)
      redirect_to onboardings_path, notice: "Great job! You've completed the #{guide_name.humanize} guide."
    else
      redirect_to onboardings_path, alert: "Invalid guide name."
    end
  end

  private

  def _set_path
    set_path onboardings_path, "Back to onboarding"
  end
end
