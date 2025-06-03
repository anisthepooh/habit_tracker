class UserMailer < ApplicationMailer
  default from: "Acme <onboarding@resend.dev>" # this domain must be verified with Resend
  def welcome_email
    @user = params[:user]
    @url = "http://example.com/login"
    mail(to: [ "delivered@resend.dev" ], subject: "hello world")
  end
end
