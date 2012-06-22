class CritiqueMailer < BaseMailer
  layout 'mailer'

  def new_critique(recipient, round_audio_visual, audio_visual, user)
    @recipient = recipient
    @round_audio_visual = round_audio_visual
    @audio_visual = audio_visual
    @user = user
    
    mail(to: recipient.email,
         subject: I18n.t(
          "mailer.subjects.critique.new",
          audio_visual: audio_visual.title))
  end

  def updated_critique(recipient, round_audio_visual, audio_visual, user)
    @recipient = recipient
    @round_audio_visual = round_audio_visual
    @audio_visual = audio_visual
    @user = user
    
    mail(to: recipient.email,
         subject: I18n.t(
          "mailer.subjects.critique.updated",
          audio_visual: audio_visual.title))
  end
end
