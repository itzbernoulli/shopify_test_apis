class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :verified_email
      t.string :total_spent
      t.string :customer_updated_at
      t.timestamps
    end
  end
end
