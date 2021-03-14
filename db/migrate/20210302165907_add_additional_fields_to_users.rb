class AddAdditionalFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :nickname, :string, default: '', null: false
    add_column :users, :phone, :integer, limit: 8
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :date_of_birth, :date
  end

  change_column_null :users, :email, false
end
