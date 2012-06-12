class CritiqueComponentsController < ApplicationController
  before_filter :authenticate_user!

  # POST /critique_components/reply
  def reply
    # Get the critique component (and its critique and audio visual).
    if !params[:id].nil?
      component = CritiqueComponent
        .includes(critique: :audio_visual)
        .joins(critique: :audio_visual)
        .where(id: params[:id])
        .first

      # Only proceed with adding the reply if the current user is the
      # author of the audio visual.
      if !component.nil? and
         component.critique.audio_visual.user_id == current_user.id
        
        # Set the reply content and save.
        component.reply = params[:reply]
         
        if component.save!
          redirect_to component.critique.audio_visual, notice: I18n.t("critique_component.reply.success")
        else
          render component.critique.audio_visual, notice: I18n.t("critique_component.reply.failure")
        end
      end
    end
  end
end
