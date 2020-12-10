class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, id: :uuid  do |t|
      t.string :store
      t.string :nonce
      t.string :access_token

      t.timestamps
    end
  end
end
