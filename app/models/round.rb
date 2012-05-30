class Round < ActiveRecord::Base
  belongs_to :folio

  attr_accessible :end_date, :name, :start_date, :folio_id

  validates :name, presence: true
  validates :folio, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
