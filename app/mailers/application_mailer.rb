class ApplicationMailer < Devise::Mailer
  default from: "\"זיכרון בסלון\" <zikaronbasalon@gmail.com>"
  layout "mailer_default.html"

  def email_image_tag(image, **options)
    attachments[image] = File.read(Rails.root.join("app/assets/images/#{image}"))
    image_tag attachments[image].url, **options
  end
  
end
