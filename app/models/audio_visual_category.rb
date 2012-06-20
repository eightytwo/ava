class AudioVisualCategory < ActiveRecord::Base
  belongs_to :organisation
  has_many :audio_visuals, dependent: :restrict
  
  attr_accessible :organisation_id, :name

  validates :organisation, presence: true
  validates :name, presence: true
end
