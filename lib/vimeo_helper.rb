module VimeoHelper
  @@upload = Vimeo::Advanced::Upload.new(
    ENV['AVA_VIMEO_CONSUMER_KEY'],
    ENV['AVA_VIMEO_CONSUMER_SECRET'],
    token: ENV['AVA_VIMEO_TOKEN'],
    secret: ENV['AVA_VIMEO_TOKEN_SECRET'])

  @@videos = Vimeo::Advanced::Video.new(
    ENV['AVA_VIMEO_CONSUMER_KEY'],
    ENV['AVA_VIMEO_CONSUMER_SECRET'],
    token: ENV['AVA_VIMEO_TOKEN'],
    secret: ENV['AVA_VIMEO_TOKEN_SECRET'])

  # Obtain a ticket for a new upload.
  #
  def self.get_upload_ticket
    return @@upload.get_ticket
  end

  # Finalise the upload process by sending a complete message to Vimeo.
  #
  def self.complete_upload(ticket_id, filename)
    if ticket_id.blank? || filename.blank?
      return nil
    else
      return @@upload.complete(ticket_id, filename)
    end
  end

  # Retrieves the thumbnails for a given video.
  #
  def self.get_thumbnails(video_id)
    return nil if video_id.blank?
    
    thumbnail = nil
    data = @@videos.get_thumbnail_urls(video_id)

    # Ensure thumbnails exist for the video.
    if data and
       data['thumbnails'] and
       data['thumbnails']['thumbnail'] and
       data['thumbnails']['thumbnail'].length > 0
      # Choose the second thumbnail if available (as it is a more appropriate
      # size, otherwise choose the first.
      index = data['thumbnails']['thumbnail'].length == 1 ? 0 : 1

      # Get the thumbnail URL and store it against the audio visual.
      thumbnail = data['thumbnails']['thumbnail'][index]['_content']
      # Use the secure URL for vimeo.
      thumbnail.sub!("http://", "https://")
    end

    return thumbnail
  end

  # Deletes a given video.
  #
  def self.delete_video(video_id)
    @@videos.delete(video_id) if video_id.present?
  end
end
