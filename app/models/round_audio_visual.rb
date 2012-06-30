class RoundAudioVisual < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = 'RoundAudioVisualAuthorizer'

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
  validates :audio_visual, presence: true
  validates :audio_visual_category_id, presence: true

  after_create :send_new_notification

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

  private
  # Sends a notification to the members of the folio indicating a new
  # audio visual has been added to the round.
  #
  def send_new_notification
    self.round.folio.users.each do |recipient|
      # Skip the current user, they know they've added a new AV.
      next if recipient == self.user

      RoundAudioVisualMailer.new_audio_visual(recipient, self).deliver
    end
  end
end
