class CreateOrganisations < ActiveRecord::Migration
  def change
    create_table :organisations do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :website

      t.timestamps
    end
  end
end
