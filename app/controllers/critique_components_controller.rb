class CritiqueComponentsController < ApplicationController
  respond_to :js
  before_filter :authenticate_user!

  # POST /critique_components/reply
  def reply
    # Get the critique component (and its critique and audio visual).
    if !params[:id].nil?
      @component = CritiqueComponent
        .includes(critique: :round_audio_visual)
        .joins(critique: :round_audio_visual)
        .where(id: params[:id])
        .first

      # Only proceed with adding the reply if the current user is the
      # author of the audio visual.
      if !@component.nil? and
         @component.critique.round_audio_visual.user.id == current_user.id
        
        # Set the reply content and save.
        @component.reply = params[:reply_content]
        @component.update_record_without_timestamping
        
        respond_with(@component, :layout => !request.xhr?)
      end
    end
  end
end
