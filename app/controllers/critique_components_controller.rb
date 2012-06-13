class CritiqueComponentsController < ApplicationController
  respond_to :js
  before_filter :authenticate_user!

  # POST /critique_components/reply
  def reply
    # Get the critique component (and its critique and audio visual).
    if !params[:id].nil?
      @component = CritiqueComponent
        .includes(critique: :audio_visual)
        .joins(critique: :audio_visual)
        .where(id: params[:id])
        .first

      # Only proceed with adding the reply if the current user is the
      # author of the audio visual.
      if !@component.nil? and
         @component.critique.audio_visual.user_id == current_user.id
        
        # Set the reply content and save.
        @component.reply = params[:reply]
        
        if @component.update_record_without_timestamping
          flash[:notice] = I18n.t("critique_component.reply.success")
        end

        respond_with(@component, :layout => !request.xhr?)
      end
    end
  end
end
