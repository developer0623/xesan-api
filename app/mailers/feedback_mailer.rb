class FeedbackMailer < ApplicationMailer

  def feedback_email(user, feedback)
    @user = user
    @feedback = feedback
    mail(from: @user.email, to: Rails.application.config.feedback_email, subject: 'User Feedback')
  end
end
