class CreateAudioVisualCategories < ActiveRecord::Migration
  def change
    create_table :audio_visual_categories do |t|
      t.references :organisation, :null => false
      t.string :name, :null => false

      t.timestamps
    end
    add_index :audio_visual_categories, :organisation_id
    add_foreign_key(:audio_visual_categories, :organisations, :dependent => :delete)
  end
end
