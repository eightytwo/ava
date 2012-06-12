class AddStatusTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :status_type_id, :integer, null: false, default: 1

    add_foreign_key(:users, :status_types, dependent: :restrict)
  end
end
