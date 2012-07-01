class ContactMailer < BaseMailer
  def new_message(message)
    @message = message
    mail(:subject => "Contact from AVA")
  end
end
