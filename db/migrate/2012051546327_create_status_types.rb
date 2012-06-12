class CreateStatusTypes < ActiveRecord::Migration
  def change
    create_table :status_types do |t|
      t.string :name, null: false
      t.string :description, null: false

      t.timestamps
    end
  end
end
