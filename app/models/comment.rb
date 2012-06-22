class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  attr_accessible :content, :user_id, :audio_visual_id

  validates :user_id, presence: true
  validates :content, presence: true
  validates :commentable, presence: true

  before_save :check_update_reply_timestamp

  # Set the per page value for will_paginate.
  self.per_page = 10

  # Ensure null is inserted into the reply field if empty string.
  nilify_blanks :only => :reply

  private
  # Checks if a reply to the comment is being created or updated
  # and if so sets the reply created/updated timestamps correctly.
  def check_update_reply_timestamp
    if self.reply_changed?
      timestamp = DateTime.now
      self.reply_created_at = timestamp if self.reply_created_at.nil?
      self.reply_updated_at = timestamp
    end
  end
end
