class FeedbackController < ApiController

  # POST /help/feedback
  def send_feedback
    @feedback = params[:feedback]
    FeedbackMailer.delay.feedback_email(current_user, @feedback)
  end

end
