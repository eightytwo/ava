class AudioVisualCategory < ActiveRecord::Base
  belongs_to :organisation
  
  attr_accessible :organisation_id, :name
end
