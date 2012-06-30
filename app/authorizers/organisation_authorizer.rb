class OrganisationAuthorizer < ApplicationAuthorizer
  # Only members of an organisation can view the organisation.
  #
  def readable_by?(user)
    user.member_of_organisation?(resource)
  end

  # Only administrators of an organisation can manage the organisation.
  #
  def manageable_by?(user)
    user.administrator_of_organisation?(resource)
  end
end
