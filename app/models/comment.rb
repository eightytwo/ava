class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :audio_visual

  attr_accessible :content, :user_id, :audio_visual_id

  validates :user_id, presence: true
  validates :audio_visual_id, presence: true
  validates :content, presence: true

  # Set the per page value for will_paginate.
  self.per_page = 10
end
