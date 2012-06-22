class AudioVisual < ActiveRecord::Base
  belongs_to :user
  has_many :round_audio_visuals, dependent: :delete_all
  has_many :rounds, through: :round_audio_visuals
  has_many :comments, as: :commentable, dependent: :delete_all

  attr_accessible :description, :external_reference, :length, :location,
                  :music, :production_notes, :rating, :tags, :title, :views,
                  :user_id, :public, :thumbnail, :allow_commenting

  validates :description, presence: true
  validates :title, presence: true
  validates :user_id, presence: true
  validates :tags, presence: true
  validates :music, presence: true
  validates :location, presence: true
  validates :production_notes, presence: true

  before_save :verify_public_commenting

  # Set the per page value for will_paginate.
  self.per_page = 12

  private
  # Ensures public commenting is disabled if the audio visual is not
  # set to public.
  #
  def verify_public_commenting
    self.allow_commenting = false if !self.public
    return true
  end
end
