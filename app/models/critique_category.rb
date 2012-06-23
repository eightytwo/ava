class CritiqueCategory < ActiveRecord::Base
  belongs_to :organisation
  has_many :critique_components, dependent: :restrict
  
  attr_accessible :name, :parent_id, :organisation_id, :critiquable

  acts_as_nested_set

  validates :name, presence: true
  validates :organisation_id, presence: true

  # Gets the critique category structure for an organisation.
  #
  def self.categories_for_organisation(organisation)
    return nil if organisation.nil?

    # Get the root categories of the organisation.
    roots = CritiqueCategory
      .where(organisation_id: organisation.id)
      .order(:name)
      .roots
      .all

    # Get the descendants of each root and build the array.
    categories = []
    roots.each do |root|
      CritiqueCategory.sorted_each_with_level(root.self_and_descendants, :name) do |category, level|
        categories.append({category: category, level: level})
      end
    end

    return categories
  end
end
