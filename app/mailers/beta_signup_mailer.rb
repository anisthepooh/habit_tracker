class BetaSignupMailer < ApplicationMailer
  default from: 'noreply@bitehabit.com'

  def notify_admin
    @user_email = params[:email_address]
    mail(
      to: 'anisimow@live.dk',
      subject: 'New Beta Tester Signup - Bite Habit'
    )
  end

  def confirm_signup(user_email)
    @user_email = user_email
    mail(
      to: user_email,
      subject: 'Beta Signup Confirmation - Bite Habit'
    )
  end
end