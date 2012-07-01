class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  attr_accessible :content, :user_id, :audio_visual_id

  validates :user_id, presence: true
  validates :content, presence: true
  validates :commentable, presence: true

  before_save :check_update_reply_timestamp
  after_create :send_new_notification
  after_update :send_update_notification

  # Set the per page value for will_paginate.
  self.per_page = 10

  # Ensure null is inserted into the reply field if empty string.
  nilify_blanks :only => :reply

  private
  # Checks if a reply to the comment is being created or updated
  # and if so sets the reply created/updated timestamps correctly.
  #
  def check_update_reply_timestamp
    if self.reply_changed?
      timestamp = Time.now
      self.reply_created_at = timestamp if self.reply_created_at.nil?
      self.reply_updated_at = timestamp
    end
  end

  # Notifies the owner of the commentable resource that a new comment
  # has been added.
  #
  # Notifications are not sent if the author of the comment is the
  # same user as the owner of the commentable resource.
  #
  def send_new_notification
    if self.content_changed? and self.user != self.commentable.user
      # Determine the resource the comment is for and call the appropriate
      # mailer method.
      if self.commentable_type.constantize == RoundAudioVisual
        CommentMailer.new_round_audio_visual_comment(
          self.commentable, self.user).deliver
      end
    end
  end

  # Notifies the owner of the commentable resource that an existing
  # comment has been updated.
  #
  # Notifications are not sent if the author of the comment is the
  # same user as the owner of the commentable resource.
  #
  def send_update_notification
    if self.content_changed? and self.user != self.commentable.user
      # Determine the resource the comment is for and call the appropriate
      # mailer method.
      if self.commentable_type.constantize == RoundAudioVisual
        CommentMailer.updated_round_audio_visual_comment(
          self.commentable, self.user).deliver
      end
    end
  end
end
