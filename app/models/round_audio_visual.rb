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
