class Critique < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = 'CritiqueAuthorizer'

  belongs_to :round_audio_visual
  belongs_to :user
  has_many :critique_components, inverse_of: :critique, dependent: :delete_all
  
  attr_accessible :round_audio_visual_id, :user_id,
                  :critique_components_attributes
  accepts_nested_attributes_for :critique_components

  validates :round_audio_visual_id, presence: true
  validates :user_id, presence: true

  before_update :check_update_modified
  after_create :send_new_notification
  after_update :send_update_notification

  private
  # Checks if any of the critique components were modified and
  # if so sets the updated_at field of the critique to now.
  #
  def check_update_modified
    self.critique_components.each do |component|
      if component.changed.count > 0
        self.updated_at = DateTime.now
        break
      end
    end
  end

  # Sends a notification to the audio visual owner indicating a new
  # critique has been posted.
  #
  def send_new_notification
    self.critique_components.each do |component|
      if component.changed.count > 0
        CritiqueMailer.new_critique(self.round_audio_visual, self.user).deliver
        break
      end
    end
  end

  # Sends a notification to the audio visual owner indicating an existing
  # critique has been updated.
  #
  def send_update_notification
    self.critique_components.each do |component|
      if component.changed.count > 0
        CritiqueMailer.updated_critique(
          self.round_audio_visual, self.user).deliver
        break
      end
    end
  end
end
