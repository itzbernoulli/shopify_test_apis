class AddScopesToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :scopes, :string
  end
end
