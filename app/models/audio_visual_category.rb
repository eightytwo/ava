class AudioVisualCategory < ActiveRecord::Base
  belongs_to :organisation
  
  attr_accessible :organisation_id, :name

  validates :organisation, presence: true
  validates :name, presence: true
end
