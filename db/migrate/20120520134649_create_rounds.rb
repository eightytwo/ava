class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.string :name, null: false
      t.references :folio, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false

      t.timestamps
    end
    add_index :rounds, :folio_id
    add_foreign_key(:rounds, :folios, dependent: :delete)
  end
end
