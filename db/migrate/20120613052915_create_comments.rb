class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, null: false
      t.text :content, null: false
      t.belongs_to :commentable, polymorphic: true
      t.text :reply
      t.datetime :reply_created_at
      t.datetime :reply_updated_at

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, [:commentable_id, :commentable_type]
    add_foreign_key(:comments, :users, dependent: :delete)
  end
end
