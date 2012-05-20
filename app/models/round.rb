class Round < ActiveRecord::Base
  belongs_to :folio

  attr_accessible :end_date, :name, :start_date, :folio
  accepts_nested_attributes_for :folio
end
