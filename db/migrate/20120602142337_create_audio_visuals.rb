class CreateAudioVisuals < ActiveRecord::Migration
  def change
    create_table :audio_visuals do |t|
      t.references :user, null: false
      t.string :title, null: false
      t.string :description, null: false
      t.integer :views, default: 0
      t.decimal :rating
      t.string :external_reference
      t.string :thumbnail
      t.string :music, null: false
      t.string :location, null: false
      t.string :production_notes, null: false
      t.string :tags, null: false
      t.integer :length
      t.boolean :public, null:false, default: false
      t.boolean :allow_commenting, null:false, default: false

      t.timestamps
    end
    add_index :audio_visuals, :user_id
    add_foreign_key(:audio_visuals, :users, dependent: :delete)
  end
end
