class Critique < ActiveRecord::Base
  belongs_to :audio_visual
  belongs_to :user
  has_many :critique_components, inverse_of: :critique, dependent: :delete_all
  
  attr_accessible :audio_visual_id, :user_id, :critique_components_attributes
  accepts_nested_attributes_for :critique_components

  validates :audio_visual_id, presence: true
  validates :user_id, presence: true

  before_update :check_update_modified

  private
  # Checks if any of the critique components were modified and
  # if so sets the updated_at field of the critique to now.
  def check_update_modified
    self.critique_components.each do |component|
      if component.changed.count > 0
        self.updated_at = DateTime.now
        break
      end
    end
  end
end
