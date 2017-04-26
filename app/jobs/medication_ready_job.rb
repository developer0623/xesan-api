class MedicationReadyJob

  def logger
    @logger ||= Delayed::Worker.logger
  end

  def pusher
    @pusher ||= Grocer.pusher(
      certificate: Rails.application.config.apn_cert,
      gateway: Rails.application.config.apn_gateway,
      passphrase: ENV['XENAPI_APN_CERT_PASSPHRASE'],
      retries: 3
    )
  end

  def perform(device_tokens, not_hash)
    device_tokens.uniq.each do |device_token|
      notification = Grocer::Notification.new(
        device_token: device_token,
        alert: not_hash[:alert],
        category: not_hash[:category]
      )
      notification.custom = not_hash[:custom] if not_hash[:custom]
      pusher.push(notification)
    end
  end
end
