class CritiqueComponent < ActiveRecord::Base
  belongs_to :critique, inverse_of: :critique_components
  belongs_to :critique_category
  
  attr_accessible :content, :reply, :reply_created_at, :reply_updated_at,
                  :critique_id, :critique_category_id, :critique_category

  validates :critique_id, presence: true
  validates :critique_category_id, presence: true

  before_save :check_update_reply_timestamp

  # Ensure null is inserted into the reply field if empty string.
  nilify_blanks :only => :reply

  private
  # Checks if a reply to the critique component is being created or updated
  # and if so sets the reply created/updated timestamps correctly.
  def check_update_reply_timestamp
    if self.reply_changed?
      timestamp = DateTime.now
      self.reply_created_at = timestamp if self.reply_created_at.nil?
      self.reply_updated_at = timestamp
    end
  end
end
