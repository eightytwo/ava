class OrganisationAdminAuthorizer < ApplicationAuthorizer
  def readable_by?(user)
    user.organisations.include?(resource)
  end

  def manageable_by?(user)
    user.administered_organisations.include?(resource)
  end
end
