class AudioVisual < ActiveRecord::Base
  require 'vimeo_helper.rb'

  include Authority::Abilities
  self.authorizer_name = 'AudioVisualAuthorizer'

  belongs_to :user
  has_many :round_audio_visuals, dependent: :delete_all
  has_many :rounds, through: :round_audio_visuals
  has_many :comments, as: :commentable, dependent: :delete_all

  attr_accessible :description, :external_reference, :length, :location,
                  :music, :production_notes, :rating, :tags, :title, :views,
                  :user_id, :thumbnail, :allow_commenting

  validates :description, presence: true
  validates :title, presence: true
  validates :user_id, presence: true
  validates :tags, presence: true
  validates :music, presence: true
  validates :location, presence: true
  validates :production_notes, presence: true

  before_save :verify_public_commenting
  before_save :lower_case_tags
  after_destroy :delete_video

  # Set the per page value for will_paginate.
  self.per_page = 12

  # Fetches thumbnails for any audio visuals which do not one.
  #
  def self.fetch_thumbnails
    missing_thumbs = AudioVisual.where(thumbnail: nil)
    
    if missing_thumbs and missing_thumbs.length > 0
      missing_thumbs.each do |av|
        thumbnail = VimeoHelper.get_thumbnails(av.external_reference)
        if thumbnail
          av.thumbnail = thumbnail
          av.save
        end
      end
    end
  end

  private
  # Ensures public commenting is disabled if the audio visual is not
  # set to public.
  #
  def verify_public_commenting
    self.allow_commenting = false if !self.public
    return true
  end

  # Ensures tags are in lower case.
  #
  def lower_case_tags
    self.tags.downcase!
  end

  # Removes the actual video file from external storage.
  #
  def delete_video
    VimeoHelper.delete_video(self.external_reference)
  end
end
