class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    mail(to: [ @user.email_address ], subject: "Welcome to Bite Habit")
  end
end
