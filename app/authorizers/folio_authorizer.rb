class FolioAuthorizer < ApplicationAuthorizer
  # Only members of a folio can view the folio.
  #
  def readable_by?(user)
    user.folios.include?(resource) ||
    user.administered_organisations.include?(resource.organisation)
  end

  # A user who is either an administrator of the folio or an administrator
  # of the folio's organisation can manage the folio.
  #
  def manageable_by?(user)
    user.administered_folios.include?(resource) ||
    user.administered_organisations.include?(resource.organisation)
  end
end
