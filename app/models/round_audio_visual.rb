class RoundAudioVisual < ActiveRecord::Base
  belongs_to :round
  belongs_to :audio_visual
  belongs_to :audio_visual_category
  has_many :critiques, dependent: :delete_all
  has_many :comments, as: :commentable, dependent: :delete_all
  
  attr_accessible :round_id, :audio_visual_category_id,
                  :allow_commenting, :allow_critiquing,
                  :audio_visual_attributes

  accepts_nested_attributes_for :audio_visual

  validates :round_id, presence: true
  validates :audio_visual_category_id, presence: true

  # Gets the owner of the audio visual.
  #
  def user
    self.audio_visual.user
  end

  # Checks if the comments associated with this round audio visual
  # can be viewed by a given user.
  #
  def comments_visible_to?(user)
    visible = false

    # Get the round, folio and organisation associated with this
    # round audio visual in one db hit.
    round = Round
      .includes(folio: :organisation)
      .joins(folio: :organisation)
      .where(id: self.round_id)
      .first

    if !round.nil?
      # Get a summary of the user's membership in the organisation/folio.
      membership = user.organisation_membership_summary(
        round.folio.organisation, round.folio)

      if !membership.nil? and
        (membership[:organisation_admin] or membership[:folio_member])
        visible = true
      end
    end

    return visible
  end

  # Checks if this round audio visual can be commented on by a
  # given user.
  #
  def accepts_comments_from?(user)
    accepts = false

    # Get the round, folio and organisation associated with this
    # round audio visual in one db hit.
    round = Round
      .includes(folio: :organisation)
      .joins(folio: :organisation)
      .where(id: self.round_id)
      .first

    if !round.nil?
      # Get a summary of the user's membership in the organisation/folio.
      membership = user.organisation_membership_summary(
        round.folio.organisation, round.folio)

      if !membership.nil? and membership[:folio_member]
        accepts = true
      end
    end

    return accepts
  end

  # Sends a notification to the owner of the audio visual that a new comment
  # has been added.
  def send_new_comment_notification(user)
    if user.id != self.audio_visual.user_id
      CommentMailer.new_comment(
        self.audio_visual.user, self.audio_visual, user
      ).deliver
    end
  end

  # Sends a notification to the owner of the audio visual that a new comment
  # has been added.
  def send_updated_comment_notification(user)
    if user.id != self.audio_visual.user_id
      CommentMailer.updated_comment(
        self.audio_visual.user, self.audio_visual, user
      ).deliver
    end
  end
end
