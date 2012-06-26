module VimeoHelper
  @@upload = Vimeo::Advanced::Upload.new(
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
    if ticket_id.nil? || filename.nil?
      return nil
    else
      return @@upload.complete(ticket_id, filename)
    end
  end
end
