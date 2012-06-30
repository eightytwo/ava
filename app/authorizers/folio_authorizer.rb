class FolioAuthorizer < ApplicationAuthorizer
  # Only members of a folio or an organisation administrator can view the folio.
  #
  def readable_by?(user)
    user.member_of_folio?(resource) or
    user.administrator_of_organisation?(resource.organisation)
  end

  # Only contributors of a folio can add content.
  #
  def contributable_by?(user)
    user.contributor_of_folio?(resource)
  end

  # A user who is either an administrator of the folio or an administrator
  # of the folio's organisation can manage the folio.
  #
  def manageable_by?(user)
    user.administrator_of_folio?(resource) or
    user.administrator_of_organisation?(resource.organisation)
  end
end
