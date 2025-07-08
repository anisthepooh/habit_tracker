class BetaSignupsController < ApplicationController
  allow_unauthenticated_access

  def create
    email = params[:email_address]

    if email.present?
      # Send notification via noticed to admin user
      admin_user = User.find_by(role: "admin") || User.first
      BetaSignupNotification.with(email_address: email).deliver(admin_user)

      redirect_to become_beta_path, notice: "Thank you for your interest! We'll be in touch soon."
    else
      redirect_to become_beta_path, alert: "Please provide a valid email address."
    end
  end
end
