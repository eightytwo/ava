class CreateCritiques < ActiveRecord::Migration
  def change
    create_table :critiques do |t|
      t.references :round_audio_visual, null: false
      t.references :user, null: false

      t.timestamps
    end
    add_index :critiques, :round_audio_visual_id
    add_index :critiques, :user_id
    add_foreign_key(:critiques, :round_audio_visuals, dependent: :delete)
    add_foreign_key(:critiques, :users, dependent: :delete)
  end
end
