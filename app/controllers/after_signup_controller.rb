class AfterSignupController < ApplicationController
  include Wicked::Wizard
  steps :info, :customize, :intro

  layout "after_signup"

  before_action :require_authentication
  before_action :set_user
  before_action :set_page_data

  def show
    case step
    when :info
      @user.build_user_configuration unless @user.user_configuration
    when :customize
      # Set up any data needed for customize step
    when :intro
      # Final step
    end
    render_wizard
  end

  def update
    case step
    when :info
      @user.build_user_configuration unless @user.user_configuration
      if @user.update(user_params_for_step)
        redirect_to next_wizard_path
      else
        render_wizard
      end
    when :customize
      if @user.update(user_params_for_step)
        redirect_to next_wizard_path
      else
        render_wizard
      end
    when :intro
      if @user.update(after_signup_completed: true)
        redirect_to home_path, notice: "Welcome! Your profile is now complete."
      else
        render_wizard
      end
    end
  end

  private

  def set_user
    @user = Current.user
  end

  def set_page_data
    case step
    when :info
      @page_title = "Complete Your Profile"
      @page_subtitle = "Let's get to know you better"
    when :customize
      @page_title = "Customize Your Experience"
      @page_subtitle = "Make it yours with themes and preferences"
    when :intro
      @page_title = "Welcome to Habit Tracker!"
      @page_subtitle = "You're all set to start building better habits"
    end
  end

  def user_params_for_step
    case step
    when :info
      params.require(:user).permit(:first_name, :last_name, :email_address, :avatar, :remove_avatar)
    when :customize
      params.require(:user).permit(:card_background, user_configuration_attributes: [ :newsletter_accepted ])
    when :intro
      {}
    end
  end
end
