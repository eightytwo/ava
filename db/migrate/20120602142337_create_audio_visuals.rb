class CreateAudioVisuals < ActiveRecord::Migration
  def change
    create_table :audio_visuals do |t|
      t.references :user, null: false
      t.references :round
      t.string :title, null: false
      t.string :description, null: false
      t.references :audio_visual_category
      t.integer :views, default: 0
      t.decimal :rating
      t.string :external_reference
      t.string :thumbnail
      t.string :music
      t.string :location
      t.string :production_notes
      t.string :tags
      t.integer :length
      t.boolean :allow_critiquing, null: false, default: false
      t.boolean :allow_commenting, null: false, default: false
      t.boolean :public, null:false, default: false

      t.timestamps
    end
    add_index :audio_visuals, :user_id
    add_index :audio_visuals, :round_id
    add_index :audio_visuals, :audio_visual_category_id
    add_foreign_key(:audio_visuals, :users, dependent: :delete)
    add_foreign_key(:audio_visuals, :rounds, dependent: :delete)
    add_foreign_key(:audio_visuals, :audio_visual_categories)
  end
end
