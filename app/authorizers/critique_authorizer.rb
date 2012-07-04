class CritiqueAuthorizer < ApplicationAuthorizer
  # Only members of a folio or an organisation administrator can view the folio.
  #
  def readable_by?(user)
    user.contributor_of_folio?(resource.round_audio_visual.round.folio) or
    user.administrator_of_organisation?(resource.round_audio_visual.round.folio.organisation)
  end

  # A critique can only be updated by its owner.
  #
  def updatable_by?(user)
    user == resource.user
  end

  # A critique can only be deleted by its owner.
  #
  def deletable_by?(user)
    user == resource.user
  end
end
