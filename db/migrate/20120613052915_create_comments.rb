class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, null: false
      t.references :audio_visual, null: false
      t.string :content, null: false
      t.string :reply
      t.datetime :reply_created_at
      t.datetime :reply_updated_at

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :audio_visual_id
    add_foreign_key(:comments, :users, dependent: :delete)
    add_foreign_key(:comments, :audio_visuals, dependent: :delete)
  end
end
