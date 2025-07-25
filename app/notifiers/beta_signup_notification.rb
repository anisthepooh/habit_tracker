class BetaSignupNotification < ApplicationNotifier
  deliver_by :email, mailer: "BetaSignupMailer", method: "notify_admin"

  required_param :email_address

  def message
    "New beta tester signup: #{params[:email_address]}"
  end

  def url
    become_beta_url
  end
end