class OverrideRecipient
  def self.delivering_email(mail)
    mail.to = ENV["SENDGRID_USERNAME"]
  end
end
ActionMailer::Base.register_interceptor(OverrideRecipient)