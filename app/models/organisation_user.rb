class OrganisationUser < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :user
  
  attr_accessible :admin
end
