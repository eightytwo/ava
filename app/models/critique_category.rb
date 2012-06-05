class CritiqueCategory < ActiveRecord::Base
  belongs_to :organisation
  
  attr_accessible :lft, :name, :parent_id, :rgt, :organisation_id

  acts_as_nested_set

  validates :name, presence: true
  validates :organisation, presence: true
end
