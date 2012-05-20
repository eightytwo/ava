class OrganisationUser < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :user
  
  attr_accessible :organisation, :user, :admin
  accepts_nested_attributes_for :organisation, :user
end
