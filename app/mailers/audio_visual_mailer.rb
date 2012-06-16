class AudioVisualMailer < BaseMailer
  layout 'mailer'

  def new_audio_visual(recipient, audio_visual, round, user)
    @recipient = recipient
    @audio_visual = audio_visual
    @round = round
    @user = user
    
    mail(to: recipient.email,
         subject: I18n.t("mailer.subjects.new_audio_visual", round: round.name))
  end
end
