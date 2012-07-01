class AudioVisualAuthorizer < ApplicationAuthorizer
  # A public audio visual is readable by anyone, otherwise only the audio
  # visual owner or a site administrator can read an audio visual.
  #
  def readable_by?(user)
    resource.public or
    resource.user == user or
    user.admin?
  end

  # Only the owner of an audio visual or a site administrator can manage
  # an audio visual.
  #
  def manageable_by?(user)
    resource.user == user or user.admin?
  end
end
