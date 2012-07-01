class Contact
  include ActiveAttr::Model

  attribute :name
  attribute :email
  attribute :body

  validates :name, presence: true
  validates :email, presence: true, format: { with: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i } 
  validates :body, presence: true
end
