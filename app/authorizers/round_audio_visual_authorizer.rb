class RoundAudioVisualAuthorizer < ApplicationAuthorizer
  # Only members of a folio or an organisation administrator can view the
  # round audio visual.
  #
  def readable_by?(user)
    user.member_of_folio?(resource.round.folio) or
    user.administrator_of_organisation?(resource.round.folio.organisation)
  end

  # A user can critique a round audio visual if:
  # - the round audio visual is flagged as accepting critiques
  # - the user is a folio contributor
  # - the user has not already critiqued the round audio visual
  # - the user is not the author of the audio visual
  #
  def critiquable_by?(user)
    resource.allow_critiquing and
    user.contributor_of_folio?(resource.round.folio) and
    !user.has_critiqued_audio_visual(resource) and
    user != resource.user
  end

  # A member of the folio can comment on the audio visual provided the
  # audio visual is marked as allowing comments.
  #
  def commentable_by?(user)
    user.member_of_folio?(resource.round.folio) and
    resource.allow_commenting
  end

  # Only the owner of the audio visual, an administrator of the audio visual's
  # folio or an organisation administrator can manage a round audio visual.
  #
  def manageable_by?(user)
    resource.user == user or
    user.administrator_of_organisation?(resource.round.folio.organisation) or
    user.admin?
  end
end
