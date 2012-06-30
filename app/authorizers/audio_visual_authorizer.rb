class AudioVisualAuthorizer < ApplicationAuthorizer
  def readable_by?(user)
    resource.public or resource.user == user or user.admin?
  end

  # Only the owner of an audio visual or a site administrator can manage
  # an audio visual.
  #
  def manageable_by?(user)
    resource.user == user or user.admin?
  end
end
