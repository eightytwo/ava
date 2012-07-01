class CommentMailer < BaseMailer
  layout 'mailer'

  def new_round_audio_visual_comment(round_audio_visual, user)
    @recipient = round_audio_visual.user
    @round_audio_visual = round_audio_visual
    @audio_visual = round_audio_visual.audio_visual
    @user = user
    
    mail(to: @recipient.email,
         subject: I18n.t(
          "mailer.subjects.comment.new",
          audio_visual: @audio_visual.title))
  end

  def updated_round_audio_visual_comment(round_audio_visual, user)
    @recipient = round_audio_visual.user
    @round_audio_visual = round_audio_visual
    @audio_visual = round_audio_visual.audio_visual
    @user = user
    
    mail(to: @recipient.email,
         subject: I18n.t(
          "mailer.subjects.comment.updated",
          audio_visual: @audio_visual.title))
  end
end
