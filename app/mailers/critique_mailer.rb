class CritiqueMailer < BaseMailer
  layout 'mailer'

  def new_critique(recipient, audio_visual, user)
    @recipient = recipient
    @audio_visual = audio_visual
    @user = user
    
    mail(to: recipient.email,
         subject: I18n.t(
          "mailer.subjects.new_critique",
          audio_visual: audio_visual.title))
  end

  def new_critique(recipient, audio_visual, user)
    @recipient = recipient
    @audio_visual = audio_visual
    @user = user
    
    mail(to: recipient.email,
         subject: I18n.t(
          "mailer.subjects.updated_critique",
          audio_visual: audio_visual.title))
  end
end
