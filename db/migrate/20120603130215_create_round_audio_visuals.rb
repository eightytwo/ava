class CreateRoundAudioVisuals < ActiveRecord::Migration
  def change
    create_table :round_audio_visuals do |t|
      t.references :round, null: false
      t.references :audio_visual, null: false
      t.references :audio_visual_category, null: false
      t.boolean :allow_critiquing, null: false, default: false
      t.boolean :allow_commenting, null: false, default: false

      t.timestamps
    end
    add_index :round_audio_visuals, :round_id
    add_index :round_audio_visuals, :audio_visual_id
    add_index :round_audio_visuals, :audio_visual_category_id
    add_foreign_key(:round_audio_visuals, :rounds, dependent: :delete)
    add_foreign_key(:round_audio_visuals, :audio_visuals, dependent: :delete)
    add_foreign_key(:round_audio_visuals, :audio_visual_categories, dependent: :restrict)
  end
end
