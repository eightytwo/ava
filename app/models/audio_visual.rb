class AudioVisual < ActiveRecord::Base
  belongs_to :user
  belongs_to :round
  belongs_to :audio_visual_category

  attr_accessible :description, :external_reference, :length, :location,
                  :music, :production_notes, :rating, :tags, :title, :views,
                  :round_id, :user_id, :audio_visual_category_id,
                  :allow_critiquing, :allow_commenting, :public,
                  :audio_visual_category_id

  validates :description, presence: true
  validates :title, presence: true
  validates :user_id, presence: true
end
