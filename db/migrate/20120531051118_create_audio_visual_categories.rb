class CreateAudioVisualCategories < ActiveRecord::Migration
  def change
    create_table :audio_visual_categories do |t|
      t.references :organisation, null: false
      t.string :name, null: false
      t.references :status_type, null: false, default: 1

      t.timestamps
    end
    add_index :audio_visual_categories, :organisation_id
    add_foreign_key(:audio_visual_categories, :organisations, dependent: :delete)
    add_foreign_key(:audio_visual_categories, :status_types, dependent: :restrict)
  end
end
