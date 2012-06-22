class RoundAudioVisualMailer < BaseMailer
  layout 'mailer'

  def new_audio_visual(recipient, round_audio_visual, audio_visual, round, user)
    @recipient = recipient
    @round_audio_visual = round_audio_visual
    @audio_visual = audio_visual
    @round = round
    @user = user
    
    mail(to: recipient.email,
      subject: I18n.t(
        "mailer.subjects.round_audio_visual.new",
        round: round.name))
  end
end
