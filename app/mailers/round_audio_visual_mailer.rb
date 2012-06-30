class RoundAudioVisualMailer < BaseMailer
  layout 'mailer'

  def new_audio_visual(recipient, round_audio_visual)
    @recipient = recipient
    @round_audio_visual = round_audio_visual
    
    mail(to: recipient.email,
      subject: I18n.t(
        "mailer.subjects.round_audio_visual.new",
        round: @round_audio_visual.round.name))
  end
end
