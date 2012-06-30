class OrganisationAuthorizer < ApplicationAuthorizer
  # Only members of an organisation can view the organisation.
  #
  def readable_by?(user)
    user.organisations.include?(resource)
  end

  # Only administrators of an organisation can manage the organisation.
  #
  def manageable_by?(user)
    user.administered_organisations.include?(resource)
  end
end
