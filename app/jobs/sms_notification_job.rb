class SmsNotificationJob

  def logger
    @logger ||= Delayed::Worker.logger
  end

  def client
    @client ||= Twilio::REST::Client.new(
      Rails.application.config.twilio_sid,
      ENV['XENAPI_TWILIO_AUTH_TOKEN']
    )
  end

  def perform(phone_numbers, msg)
    phone_numbers.uniq.each do |phone_number|
      # TODO: validate phone_number? (E.164)
      message = client.account.messages.create(
        :body => msg,
        :to => phone_number,
        :from => Rails.application.config.twilio_number
      )
      # TODO: save notification record for receipt confirmation
    end
  end
end
