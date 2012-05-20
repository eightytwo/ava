class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.string :name
      t.references :folio
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
    add_index :rounds, :folio_id
    add_foreign_key(:rounds, :folios, :dependent => :delete)
  end
end
