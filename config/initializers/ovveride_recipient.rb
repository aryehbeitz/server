class OverrideRecipient
  def self.delivering_email(mail)
    mail.to = ENV["OVVERIDE_RECIPIENT"]
  end
end
ActionMailer::Base.register_interceptor(OverrideRecipient)