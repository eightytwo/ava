class CommentMailer < BaseMailer
  layout 'mailer'

  def new_comment(recipient, round_audio_visual, audio_visual, user)
    @recipient = recipient
    @round_audio_visual = round_audio_visual
    @audio_visual = audio_visual
    @user = user
    
    mail(to: recipient.email,
         subject: I18n.t(
          "mailer.subjects.comment.new",
          audio_visual: audio_visual.title))
  end

  def updated_comment(recipient, round_audio_visual, audio_visual, user)
    @recipient = recipient
    @round_audio_visual = round_audio_visual
    @audio_visual = audio_visual
    @user = user
    
    mail(to: recipient.email,
         subject: I18n.t(
          "mailer.subjects.comment.updated",
          audio_visual: audio_visual.title))
  end
end
