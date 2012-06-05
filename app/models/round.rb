class Round < ActiveRecord::Base
  belongs_to :folio

  attr_accessible :end_date, :name, :start_date, :folio_id

  validates :name, presence: true
  validates :folio, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :start_before_end

  # Returns true if the round is open, i.e. today's date falls between
  # the start and end date of the round. Returns false otherwise.
  #
  def open?
    return (self.start_date..self.end_date).cover?(Date.today)
  end

  private
  # Validates that the start date of the round is before the end date.
  #
  def start_before_end
    if self.start_date >= self.end_date
      errors[:base] << I18n.t("round.validation.start_before_end")
    end
  end
end
