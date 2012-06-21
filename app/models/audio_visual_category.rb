class AudioVisualCategory < ActiveRecord::Base
  belongs_to :organisation
  has_many :round_audio_visuals, dependent: :restrict
  has_many :audio_visuals, through: :round_audio_visuals
  
  attr_accessible :organisation_id, :name

  validates :organisation, presence: true
  validates :name, presence: true
end
