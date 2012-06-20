class AudioVisual < ActiveRecord::Base
  belongs_to :user
  belongs_to :round
  belongs_to :audio_visual_category
  has_many :critiques, dependent: :delete_all
  has_many :comments, dependent: :delete_all

  attr_accessible :description, :external_reference, :length, :location,
                  :music, :production_notes, :rating, :tags, :title, :views,
                  :round_id, :user_id, :audio_visual_category_id,
                  :allow_critiquing, :allow_commenting, :public,
                  :thumbnail

  validates :description, presence: true
  validates :title, presence: true
  validates :user_id, presence: true
  validates :tags, presence: true
  validates :music, presence: true
  validates :location, presence: true
  validates :production_notes, presence: true
  validates :audio_visual_category_id, presence: true, if: :round_id?

  # Set the per page value for will_paginate.
  self.per_page = 12
end
