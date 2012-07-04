class ContactMailer < BaseMailer
  def new_message(message)
    @message = message
    mail(:subject => t("mailer.subjects.contact"))
  end
end
