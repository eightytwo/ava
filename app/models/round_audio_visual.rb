class RoundAudioVisual < ActiveRecord::Base
  belongs_to :round
  belongs_to :audio_visual
  belongs_to :audio_visual_category
  has_many :critiques, dependent: :delete_all
  
  attr_accessible :round_id, :audio_visual_category_id,
                  :allow_commenting, :allow_critiquing,
                  :audio_visual_attributes

  accepts_nested_attributes_for :audio_visual

  validates :round_id, presence: true
  validates :audio_visual_category_id, presence: true
end
